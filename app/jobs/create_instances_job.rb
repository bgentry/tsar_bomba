class CreateInstancesJob < ActiveJob::Base
  queue_as ""

  rescue_from(ActiveJob::DeserializationError) do |exception|
    puts "deserialization error during CreateInstancesJob: #{exception.inspect}"
  end

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    puts "record not found during CreateInstancesJob: #{exception.inspect}"
  end

  def perform(fleet)
    fleet.instance_count.times do
      fleet.instances.create!
    end
  end
end
