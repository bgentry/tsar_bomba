class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :provider_bootstrapped?

  private

  def provider_bootstrapped?
    @provider_bootstrapped ||= check_if_provider_bootstrapped
    true
  end

  def check_if_provider_bootstrapped
    $flipper[:provider_bootstrapped].enabled?
  end
end
