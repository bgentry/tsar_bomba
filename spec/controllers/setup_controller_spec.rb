require 'rails_helper'

RSpec.describe SetupController, :type => :controller do

  describe "GET show" do
    it "returns http success" do
      get :show
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST bootstrap" do
    before do
      $flipper[:provider_bootstrapped].disable
    end

    it "returns http success" do
      post :bootstrap
      expect(response).to redirect_to(root_path)
    end

    it "calls Providers::AWS.bootstrap!" do
      expect(::Providers::AWS).to receive(:bootstrap!)
      post :bootstrap
    end

    it "should enable the provider_bootstrapped flipper" do
      expect($flipper[:provider_bootstrapped]).to_not be_enabled
      post :bootstrap
      expect($flipper[:provider_bootstrapped]).to be_enabled
    end
  end
end
