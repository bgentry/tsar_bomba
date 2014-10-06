class FleetsController < ApplicationController
  before_action :set_fleet, only: [:show, :edit, :update, :destroy]

  # GET /fleets
  # GET /fleets.json
  def index
    @fleets = Fleet.all
  end

  # GET /fleets/1
  # GET /fleets/1.json
  def show
  end

  # GET /fleets/new
  def new
    @fleet = Fleet.new
  end

  # POST /fleets
  # POST /fleets.json
  def create
    @fleet = Fleet.new(fleet_params)

    respond_to do |format|
      if @fleet.save
        format.html { redirect_to @fleet, notice: 'Fleet was successfully created.' }
        format.json { render :show, status: :created, location: @fleet }
      else
        format.html { render :new }
        format.json { render json: @fleet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fleets/1
  # DELETE /fleets/1.json
  def destroy
    @fleet.destroy
    respond_to do |format|
      format.html { redirect_to fleets_url, notice: 'Fleet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fleet
      @fleet = Fleet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fleet_params
      params.require(:fleet).permit(:provider_region, :instance_type, :instance_count)
    end
end
