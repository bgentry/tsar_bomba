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
      flavor_id: fleet.instance_type,
      image_id: Providers::AWS.images[fleet.provider_region],
      key_name: Providers::AWS::KEY_PAIR_NAME,
      security_group_ids: Providers::AWS::SECURITY_GROUP_NAME,
    })
    update_attributes!(provider_id: resp.first.id)
    WaitForInstanceRunningJob.perform_later(self)
  end

  def running
    update_attributes!(dns_name: remote.dns_name)
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

  protected

  def enqueue_launch
    LaunchInstanceJob.perform_later(self)
  end

end
