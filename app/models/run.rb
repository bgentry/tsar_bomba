class Run < ActiveRecord::Base
  include Workflow

  belongs_to :fleet
  has_many :results, :dependent => :destroy

  after_create :enqueue_perform_run

  validates :fleet, presence: true, on: :create
  validates :state, presence: true
  validates :target, presence: true
  validates :duration, presence: true, numericality: {
    greater_than: 0,
    less_than_or_equal_to: 1800,
    message: "must be between 1 and 1800",
  }
  validates :rate, presence: true, numericality: {
    greater_than: 0,
    less_than_or_equal_to: 20000,
    message: "must be between 1 and 20000",
  }

  workflow_column :state
  workflow do
    state :initiated do
      event :start, :transitions_to => :started
    end
    state :started do
      event :fail, :transitions_to => :failed
      event :finish, :transitions_to => :finished
    end
    state :failed
    state :finished
  end

  def perform
    host_header_flag = host_header.present? ? " -header=\"Host: #{host_header}\"" : ""
    command = "echo \"GET #{target}\" | "+
      "vegeta attack -duration #{duration}s timeout=10s -rate #{rate / fleet.instances.count}"+
      "#{host_header_flag} | vegeta-encoder"
    threads = []
    fleet.instances.each do |instance|
      threads << Thread.new do
        Net::SSH.start(instance.dns_name, "ubuntu", :key_data => [instance.ssh_key_pair.private_key]) do |ssh|
          block ||= Proc.new do |ch, kind, data|
            ch[:result] ||= ""
            ch[:result] << data
          end

          channel = ssh.exec(command, &block)
          channel.on_request "exit-status" do |ch, data|
            exit_status = data.read_long
            unless exit_status == 0
              Rails.logger.error "run on instance=#{instance.id} terminated with exit status: #{exit_status}"
            end
          end
          channel.wait

          Rails.logger.debug("run on instance=#{instance.id} finished")
          json_array = channel[:result][/^(\[.*\])$/, 1]
          self.results.create!(instance: instance, raw_data: json_array)
        end
      end
    end
    threads.each(&:join)
  end

  protected

  def enqueue_perform_run
    PerformRunJob.perform_later(self)
  end
end
