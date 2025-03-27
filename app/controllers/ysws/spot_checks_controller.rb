module Ysws
  class SpotChecksController < ApplicationController
    before_action :authenticate_user!
    before_action :set_spot_check_session, only: [:new, :create]
    before_action :set_approved_project, only: [:new, :create]
    
    def new
      @spot_check = Ysws::SpotCheck.new(
        start_time: Time.current,
        spot_check_session: @spot_check_session
      )
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
      @spot_check.reviewer_name = session[:user_info]['name']
      @spot_check.reviewer_email = session[:user_info]['email']
      @spot_check.reviewer_avatar_url = session[:user_info]['image']
      @spot_check.spot_check_session = @spot_check_session

      if @spot_check.save
        redirect_to next_review_path, notice: "Spot check submitted successfully!"
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
      if params[:approved_project_id]
        @approved_project = Ysws::ApprovedProject.includes(:ysws_program).find(params[:approved_project_id])
      elsif @spot_check_session
        @approved_project = @spot_check_session.find_next_project
        if @approved_project.nil?
          @spot_check_session.update(end_time: Time.current)
          redirect_to ysws_spot_check_session_path(@spot_check_session), notice: "No more projects to review in this session!"
        end
      else
        raise ActiveRecord::RecordNotFound, "No project specified and no active session"
      end
    end

    def set_spot_check_session
      @spot_check_session = Ysws::SpotCheckSession.find(params[:spot_check_session_id]) if params[:spot_check_session_id]
    end

    def spot_check_params
      params.require(:spot_check).permit(:assessment, :notes, :start_time)
    end

    def next_review_path
      if @spot_check_session
        next_project = @spot_check_session.find_next_project
        if next_project
          new_ysws_approved_project_spot_check_path(next_project, spot_check_session_id: @spot_check_session.id)
        else
          @spot_check_session.update(end_time: Time.current)
          ysws_spot_check_session_path(@spot_check_session)
        end
      else
        ysws_new_random_review_path
      end
    end
  end
end
