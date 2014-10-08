require 'rails_helper'

RSpec.describe InstancesController, :type => :controller do

  let(:fleet) { create(:fleet) }

  # This should return the minimal set of attributes required to create a valid
  # Instance. As you add validations to Instance, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {fleet_id: fleet.id}
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # InstancesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET show" do
    let(:instance) { Instance.create! valid_attributes }

    it "assigns the parent fleet as @fleet" do
      get :show, {:id => instance.to_param, :fleet_id => fleet.to_param}, valid_session
      expect(assigns(:fleet)).to eq(fleet)
    end

    it "assigns the requested instance as @instance" do
      get :show, {:id => instance.to_param, :fleet_id => fleet.to_param}, valid_session
      expect(assigns(:instance)).to eq(instance)
    end
  end

end
