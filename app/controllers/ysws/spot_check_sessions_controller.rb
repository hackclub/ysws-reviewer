module Ysws
  class SpotCheckSessionsController < ApplicationController
    before_action :authenticate_user!

    def new
      @session = SpotCheckSession.new(filters: {})
      @programs = Program.all
    end

    def create
      @session = SpotCheckSession.new(session_params.merge(
        creator_slack_id: session[:user_slack_id],
        creator_name: session[:user_info]['name'],
        creator_email: session[:user_info]['email'],
        creator_avatar_url: session[:user_info]['image'],
        start_time: Time.current
      ))

      Rails.logger.debug "Creating SpotCheckSession with params: #{session_params.inspect}"
      Rails.logger.debug "Full session attributes: #{@session.attributes.inspect}"

      if @session.save
        Rails.logger.debug "Successfully created SpotCheckSession with ID: #{@session.id}"
        redirect_to ysws_spot_check_session_path(@session), notice: 'Spot check session created successfully.'
      else
        Rails.logger.debug "Failed to create SpotCheckSession. Errors: #{@session.errors.full_messages}"
        @programs = Program.all
        render :new, status: :unprocessable_entity
      end
    end

    def show
      @session = SpotCheckSession.find(params[:id])
    end

    private

    def session_params
      params.require(:spot_check_session).permit(
        :sampling_strategy,
        filters: [:timeframe, :start_date, :end_date, { ysws_program_ids: [] }]
      )
    end
  end
end
