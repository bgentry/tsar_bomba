require 'rails_helper'

RSpec.describe RunsController, :type => :controller do
  let(:fleet) { create(:fleet) }
  let(:valid_attributes) { attributes_for(:run).merge(fleet_id: fleet.id) }

  let(:invalid_attributes) { {fleet_id: 0, duration: 0, rate: 0} }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # RunsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all runs as @runs" do
      run = Run.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:runs)).to eq([run])
    end
  end

  describe "GET show" do
    it "assigns the requested run as @run" do
      run = Run.create! valid_attributes
      get :show, {:id => run.to_param}, valid_session
      expect(assigns(:run)).to eq(run)
    end
  end

  describe "GET new" do
    it "assigns a new run as @run" do
      get :new, {}, valid_session
      expect(assigns(:run)).to be_a_new(Run)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Run" do
        expect {
          post :create, {:run => valid_attributes}, valid_session
        }.to change(Run, :count).by(1)
      end

      it "assigns a newly created run as @run" do
        post :create, {:run => valid_attributes}, valid_session
        expect(assigns(:run)).to be_a(Run)
        expect(assigns(:run)).to be_persisted
      end

      it "redirects to the created run" do
        post :create, {:run => valid_attributes}, valid_session
        expect(response).to redirect_to(Run.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved run as @run" do
        post :create, {:run => invalid_attributes}, valid_session
        expect(assigns(:run)).to be_a_new(Run)
      end

      it "re-renders the 'new' template" do
        post :create, {:run => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested run" do
      run = Run.create! valid_attributes
      expect {
        delete :destroy, {:id => run.to_param}, valid_session
      }.to change(Run, :count).by(-1)
    end

    it "redirects to the runs list" do
      run = Run.create! valid_attributes
      delete :destroy, {:id => run.to_param}, valid_session
      expect(response).to redirect_to(runs_url)
    end
  end

end
