require 'quantile'

class RunsController < ApplicationController
  before_action :set_run, only: [:show, :edit, :update, :destroy]

  # GET /runs
  # GET /runs.json
  def index
    @runs = Run.all
  end

  # GET /runs/1
  # GET /runs/1.json
  def show
    @estimator = Quantile::Estimator.new
    query = <<-DOC
SELECT value->'Latency' AS latency_ns
FROM results, json_array_elements(results.raw_data)
WHERE results.run_id = #{@run.id} AND
  value->>'Error' = '' AND
  value->>'Code' >= '200' AND
  value->>'Code' < '300'
DOC
    ActiveRecord::Base.connection.select_values(query).each do |latency|
      @estimator.observe(latency.to_f/10**6)
    end
  end

  # GET /runs/new
  def new
    @run = Run.new
  end

  # POST /runs
  # POST /runs.json
  def create
    @run = Run.new(run_params)

    respond_to do |format|
      if @run.save
        format.html { redirect_to @run, notice: 'Run was successfully created.' }
        format.json { render :show, status: :created, location: @run }
      else
        format.html { render :new }
        format.json { render json: @run.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /runs/1
  # DELETE /runs/1.json
  def destroy
    @run.destroy
    respond_to do |format|
      format.html { redirect_to runs_url, notice: 'Run was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_run
      @run = Run.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def run_params
      params.require(:run).permit(:fleet_id, :target, :host_header, :duration, :rate)
    end
end
