require 'rails_helper'

RSpec.describe "Fleets", :type => :request do
  describe "GET /fleets" do
    it "works! (now write some real specs)" do
      get fleets_path
      expect(response).to have_http_status(200)
    end
  end
end
