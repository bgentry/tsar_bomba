json.array!(@fleets) do |fleet|
  json.extract! fleet, :id, :instance_type, :instance_count
  json.url fleet_url(fleet, format: :json)
end
