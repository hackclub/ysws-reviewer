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

      if @session.save
        redirect_to ysws_spot_check_session_path(@session), notice: 'Spot check session created successfully.'
      else
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
        filters: {
          timeframe: nil,
          ysws_program_ids: []
        }
      )
    end
  end
end
