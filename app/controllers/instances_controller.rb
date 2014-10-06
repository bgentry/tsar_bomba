class InstancesController < ApplicationController
  before_action :set_fleet, only: [:show]
  before_action :set_instance, only: [:show]

  # GET /instances/1
  # GET /instances/1.json
  def show
  end

  private
    def set_fleet
      @fleet = Fleet.find(params[:fleet_id])
    end

    def set_instance
      @instance = @fleet.instances.find(params[:id])
    end

end
