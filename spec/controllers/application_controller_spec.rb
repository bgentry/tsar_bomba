require 'rails_helper'

RSpec.describe ApplicationController, :type => :controller do
  controller do
    def index
      render text: 'OK'
    end

    def test_provider_bootstrapped
      provider_bootstrapped?
    end
  end

  describe :provider_bootstrapped? do
    subject { controller.test_provider_bootstrapped }

    it { should eq(true) }

    describe "assigns :provider_bootstrapped to the value of the :provider_bootstrapped feature" do
      it "when false" do
        $flipper[:provider_bootstrapped].disable
        get :index
        expect(assigns(:provider_bootstrapped)).to eq(false)
      end

      it "when true" do
        $flipper[:provider_bootstrapped].enable
        get :index
        expect(assigns(:provider_bootstrapped)).to eq(true)
      end
    end
  end

end

