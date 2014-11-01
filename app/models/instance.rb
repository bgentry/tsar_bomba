require 'ssh_key_pair'

class Instance < ActiveRecord::Base
  include Workflow

  belongs_to :fleet

  after_create :enqueue_launch
  before_destroy :destroy_instance

  workflow_column :state
  workflow do
    state :awaiting_launch do
      event :launch, :transitions_to => :launched
    end
    state :launched do
      event :running, :transitions_to => :running
    end
    state :running do
      event :bootstrap, :transitions_to => :ready
    end
    state :ready
  end

  def launch
    resp = Providers::AWS::fog_client.servers.create_many(1, 1, {
      flavor_id: self.fleet.instance_type,
      image_id: Providers::AWS.images[self.fleet.provider_region],
      key_name: Providers::AWS::KEY_PAIR_NAME,
      security_group_ids: Providers::AWS::SECURITY_GROUP_NAME,
    })
    update_attributes!(provider_id: resp.first.id)
    WaitForInstanceRunningJob.perform_later(self)
  end

  def running
    update_attributes!(dns_name: remote.dns_name)
    BootstrapInstanceJob.set(wait: 20.seconds).perform_later(self)
  end

  def destroy_instance
    if provider_id.present?
      Providers::AWS::fog_client.terminate_instances(provider_id)
    end
  end

  def remote
    @remote ||= if provider_id.present?
                  Providers::AWS::fog_client.servers.get(provider_id)
                end
  end

  def bootstrap
    Net::SSH.start(self.dns_name, "ubuntu", :key_data => [ssh_key_pair.private_key]) do |ssh|
      [
        "sudo apt-get update",
        "yes | sudo apt-get install git-core mercurial",
        "which go || (curl -o goinst.sh https://gist.githubusercontent.com/bgentry/3f508a2c6cb6417ad46c/raw/d3f065b9d5da740045634ef0a4dea98425528f7d/goinst.sh && chmod +x goinst.sh && sudo VERSION=1.3.3 ./goinst.sh)",
        "source /etc/profile && go get -d -u github.com/bgentry/vegeta && cd $GOPATH/src/github.com/bgentry/vegeta && git checkout buckets && go install",
        "source /etc/profile && sudo cp -f $GOPATH/bin/vegeta /usr/local/bin/vegeta",
        "source /etc/profile && go get -u github.com/bgentry/vegeta-encoder",
        "source /etc/profile && sudo cp -f $GOPATH/bin/vegeta-encoder /usr/local/bin/vegeta-encoder",
      ].each do |command|
        block ||= Proc.new do |ch, kind, data|
          ch[:result] ||= ""
          ch[:result] << data
        end

        channel = ssh.exec(command, &block)
        channel.on_request "exit-status" do |ch, data|
          exit_status = data.read_long
          unless exit_status == 0
            raise "process terminated with exit status: #{exit_status}"
          end
        end
        channel.wait

        Rails.logger.debug("SSH RESULT: \n#{channel[:result]}\n\n")
      end
    end
  end

  def ssh_key_pair
    @key ||= SSHKeyPair.first!
  end

  protected

  def enqueue_launch
    LaunchInstanceJob.perform_later(self)
  end

end
