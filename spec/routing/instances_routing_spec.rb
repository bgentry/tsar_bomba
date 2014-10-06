require "rails_helper"

RSpec.describe InstancesController, :type => :routing do
  describe "routing" do

    it "routes to #show" do
      expect(:get => "/fleets/2/instances/1").to route_to("instances#show", :id => "1", :fleet_id => "2")
    end

  end
end
