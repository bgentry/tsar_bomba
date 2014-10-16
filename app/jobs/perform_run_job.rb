class PerformRunJob < ActiveJob::Base
  queue_as :default

  rescue_from(ActiveJob::DeserializationError) do |e|
    puts "deserialization error during #{self.class.to_s}: #{e.inspect}"
  end

  def perform(run)
    run.start!
    run.perform
    run.finish!
  rescue Exception => e
    Rails.logger.error("exception during run: #{e.inspect}")
    run.fail!
  end
end
