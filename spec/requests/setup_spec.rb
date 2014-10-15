require 'rails_helper'

RSpec.describe "Setup", :type => :request do
  describe "GET /setup" do
    it "returns a 200" do
      get setup_path
      expect(response).to have_http_status(200)
    end
  end
end
