module Ysws
  class ReloadsController < ApplicationController
    before_action :authenticate_user!

    def create
      job = Ysws::ImportApprovedProjectsJob.perform_later
      render json: { job_id: job.provider_job_id }
    end

    def status
      execution = GoodJob::Execution.find_by(active_job_id: params[:job_id])
      if execution&.finished_at
        render json: {
          finished: true,
          duration: (execution.finished_at - execution.created_at).round
        }
      elsif execution&.created_at
        render json: {
          finished: false,
          running_time: (Time.current - execution.created_at).round
        }
      else
        render json: { finished: false, running_time: 0 }
      end
    end
  end
end 