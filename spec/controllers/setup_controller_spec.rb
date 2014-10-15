require 'rails_helper'

RSpec.describe SetupController, :type => :controller do

  describe "GET show" do
    it "returns http success" do
      get :show
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST bootstrap" do
    it "returns http success" do
      post :bootstrap
      expect(response).to redirect_to(root_path)
    end

    it "calls Providers::AWS.bootstrap!" do
      expect(::Providers::AWS).to receive(:bootstrap!)
      post :bootstrap
    end
  end
end
