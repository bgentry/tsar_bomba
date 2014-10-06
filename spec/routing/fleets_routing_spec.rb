require "rails_helper"

describe FleetsController do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/fleets").to route_to("fleets#index")
    end

    it "routes to #new" do
      expect(:get =>"/fleets/new").to route_to("fleets#new")
    end

    it "routes to #show" do
      expect(:get => "/fleets/1").to route_to("fleets#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/fleets").to route_to("fleets#create")
    end

    it "routes to #destroy" do
      expect(:delete => "/fleets/1").to route_to("fleets#destroy", :id => "1")
    end

  end
end

