class LaunchInstanceJob < ActiveJob::Base
  queue_as :default

  rescue_from(ActiveJob::DeserializationError) do |exception|
    puts "deserialization error during CreateInstancesJob: #{exception.inspect}"
  end

  def perform(instance)
    instance.launch!
  end
end
