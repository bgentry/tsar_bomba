class BootstrapInstanceJob < ActiveJob::Base
  queue_as :default

  rescue_from(ActiveJob::DeserializationError) do |exception|
    puts "deserialization error during #{self.class.to_s}: #{exception.inspect}"
  end

  def perform(instance)
    instance.bootstrap!
  end
end
