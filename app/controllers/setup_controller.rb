require 'providers'

class SetupController < ApplicationController
  skip_before_action :check_if_provider_bootstrapped
  skip_before_action :redirect_unless_provider_bootstrapped

  def show
  end

  def bootstrap
    ::Providers::AWS.bootstrap!
    $flipper[:provider_bootstrapped].enable

    redirect_to root_path
  end
end
