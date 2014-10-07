class WaitForInstanceRunningJob < ActiveJob::Base
  queue_as :default

  rescue_from(ActiveJob::DeserializationError) do |exception|
    puts "deserialization error during WaitForInstanceRunningJob: #{exception.inspect}"
  end

  def perform(instance)
    remote = instance.remote
    if remote.present? && remote.ready?
      instance.running!
    elsif remote.present? && remote.state != "pending"
      # it's in a state other than pending or running, bail out
    else
      retry_job wait: 10.seconds
    end
  end
end
