module Ysws
  class ReviewsController < ApplicationController
    before_action :authenticate_user!
    
    def new
      @approved_project = Ysws::ApprovedProject.includes(:ysws_program).find(params[:approved_project_id])
    end
  end
end
