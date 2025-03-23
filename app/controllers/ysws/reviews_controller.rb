module Ysws
  class ReviewsController < ApplicationController
    before_action :authenticate_user!
    
    def new
      @approved_project = Ysws::ApprovedProject.includes(:ysws_program).find(params[:approved_project_id])
    end

    def new_random
      random_project = Ysws::ApprovedProject.order('RANDOM()').first
      redirect_to new_ysws_approved_project_review_path(random_project)
    end
  end
end
