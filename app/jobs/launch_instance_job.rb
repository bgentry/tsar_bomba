class LaunchInstanceJob < ActiveJob::Base
  queue_as :default

  def perform(instance)
    instance.launch!
  end
end
