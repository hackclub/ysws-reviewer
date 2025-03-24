module Ysws
  class SpotChecksController < ApplicationController
    before_action :authenticate_user!
    before_action :set_approved_project, only: [:new, :create]
    
    def new
      @spot_check = Ysws::SpotCheck.new
      @other_projects = Ysws::ApprovedProject
        .includes(:ysws_program)
        .where(email: @approved_project.email)
        .where.not(airtable_id: @approved_project.airtable_id)
        .order(approved_at: :desc)
    end

    def create
      @spot_check = Ysws::SpotCheck.new(spot_check_params)
      @spot_check.approved_project = @approved_project
      @spot_check.reviewer_slack_id = current_user.slack_user_id

      if @spot_check.save
        redirect_to ysws_new_random_review_path, notice: "Spot check submitted successfully!"
      else
        @other_projects = Ysws::ApprovedProject
          .includes(:ysws_program)
          .where(email: @approved_project.email)
          .where.not(airtable_id: @approved_project.airtable_id)
          .order(approved_at: :desc)
        render :new, status: :unprocessable_entity
      end
    end

    def new_random
      random_project = Ysws::ApprovedProject.order('RANDOM()').first
      redirect_to new_ysws_approved_project_spot_check_path(random_project)
    end

    private

    def set_approved_project
      @approved_project = Ysws::ApprovedProject.includes(:ysws_program).find(params[:approved_project_id])
    end

    def spot_check_params
      params.require(:spot_check).permit(:assessment, :notes)
    end
  end
end
