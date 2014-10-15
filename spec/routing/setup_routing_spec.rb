require "rails_helper"

describe SetupController do
  describe "routing" do
    it "routes GET /setup to setup#show" do
      expect(:get => "/setup").to route_to("setup#show")
    end

    it "routes POST /setup to setup#show" do
      expect(:post => "/setup").to route_to("setup#bootstrap")
    end
  end
end
