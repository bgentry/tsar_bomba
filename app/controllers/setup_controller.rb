require 'providers'

class SetupController < ApplicationController
  def show
  end

  def bootstrap
    ::Providers::AWS.bootstrap!
    redirect_to root_path
  end
end
