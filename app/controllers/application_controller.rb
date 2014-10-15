class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :check_if_provider_bootstrapped
  before_action :redirect_unless_provider_bootstrapped

  private

  def check_if_provider_bootstrapped
    unless provider_bootstrapped?
      flash[:warning] = "Your provider environment has not been bootstrapped."
    end
    true
  end

  def provider_bootstrapped?
    @provider_bootstrapped ||= $flipper[:provider_bootstrapped].enabled?
  end

  def redirect_unless_provider_bootstrapped
    redirect_to setup_path unless provider_bootstrapped?
  end
end
