class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    base_query = Ysws::Program.left_joins(:approved_projects)

    @total_programs = base_query.distinct.count

    @ysws_programs = base_query
      .select("ysws_programs.*, 
              COUNT(DISTINCT ysws_approved_projects.airtable_id) AS total_projects,
              SUM(ysws_approved_projects.weighted_project_contribution) AS total_weighted_projects,
              MAX(ysws_approved_projects.approved_at) AS recent_project_at")
      .group('ysws_programs.airtable_id, ysws_programs.name')
      .order('recent_project_at DESC NULLS LAST')
    
    # Get reload job statistics from GoodJob
    @last_job = GoodJob::Execution
      .where(job_class: ['Ysws::ImportApprovedProjectsJob', 'Ysws::ImportProgramsJob'])
      .where.not(finished_at: nil)
      .order(finished_at: :desc)
      .first

    @average_runtime = GoodJob::Execution
      .where(job_class: ['Ysws::ImportApprovedProjectsJob', 'Ysws::ImportProgramsJob'])
      .where.not(finished_at: nil)
      .average("EXTRACT(epoch FROM finished_at - created_at)")
  end
end 