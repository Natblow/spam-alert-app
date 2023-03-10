class ReportsController < ApplicationController
  before_action :set_report, only: %i[ show update destroy ]

  # GET /reports
  def index
    @reports = Report.all

    render json: @reports
  end

  # GET /reports/1
  def show
    render json: @report
  end

  # POST /reports
  def create
    if params[:Type] == "SpamNotification"
      @slack_notifier.ping("Spam notification for #{params[:Email]}")
      render json: { message: "Spam notification sent" }, status: :ok
    else
      render json: { message: "All good" }, status: :ok 
    end
  end

  # PATCH/PUT /reports/1
  def update
    if @report.update(report_params)
      render json: @report
    else
      render json: @report.errors, status: :unprocessable_entity
    end
  end

  # DELETE /reports/1
  def destroy
    @report.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def report_params
      params.fetch(:report, {})
    end
end
