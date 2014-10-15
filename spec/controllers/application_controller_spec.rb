require 'rails_helper'

RSpec.describe ApplicationController, :type => :controller do
  controller do
    def index
      render text: 'OK'
    end

    def test_check_if_provider_bootstrapped
      check_if_provider_bootstrapped
    end

    def test_provider_bootstrapped
      provider_bootstrapped?
    end
  end

  describe "sets the warning flash when :provider_bootstrapped is not enabled" do
    before do
      $flipper[:provider_bootstrapped].disable
      get :index
    end

    it { should set_the_flash[:warning].to('Your provider environment has not been bootstrapped.') }

    it { should redirect_to(setup_path) }
  end

  describe :check_if_provider_bootstrapped do
    subject { controller.test_check_if_provider_bootstrapped }

    it { should eq(true) }

    describe "assigns :provider_bootstrapped to the value of the :provider_bootstrapped feature" do
      it "when false" do
        $flipper[:provider_bootstrapped].disable
        controller.test_check_if_provider_bootstrapped
        expect(assigns(:provider_bootstrapped)).to eq(false)
      end

      it "when true" do
        $flipper[:provider_bootstrapped].enable
        controller.test_check_if_provider_bootstrapped
        expect(assigns(:provider_bootstrapped)).to eq(true)
      end

      describe "sets the warning flash when :provider_bootstrapped is not enabled" do
        subject { controller }

        before do
          $flipper[:provider_bootstrapped].disable
          get :index
        end

        it { should set_the_flash[:warning].to('Your provider environment has not been bootstrapped.') }
      end

    end
  end

  describe :provider_bootstrapped? do
    subject { controller.test_provider_bootstrapped }

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

