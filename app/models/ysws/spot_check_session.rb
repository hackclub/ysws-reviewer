module Ysws
  class SpotCheckSession < ApplicationRecord
    enum :sampling_strategy, { random: 0, highest_hours: 1 }, default: :random

    validates :filters, presence: true
    validates :creator_slack_id, presence: true
    validates :creator_name, presence: true
    validates :creator_email, presence: true
    validates :creator_avatar_url, presence: true
    validates :start_time, presence: true

    has_many :spot_checks, dependent: :nullify

    def duration
      return nil if start_time.nil? || end_time.nil?
      end_time - start_time
    end

    def find_next_project
      base_query = Ysws::ApprovedProject.includes(:ysws_program)

      Rails.logger.debug "SpotCheckSession#find_next_project - Initial count: #{base_query.count}"
      Rails.logger.debug "SpotCheckSession#find_next_project - Filters: #{filters.inspect}"
      Rails.logger.debug "SpotCheckSession#find_next_project - Sampling strategy: #{sampling_strategy}"

      # Apply timeframe filter
      case filters["timeframe"]
      when "24h"
        base_query = base_query.where("approved_at > ?", 24.hours.ago)
      when "7d"
        base_query = base_query.where("approved_at > ?", 7.days.ago)
      when "30d"
        base_query = base_query.where("approved_at > ?", 30.days.ago)
      end

      Rails.logger.debug "SpotCheckSession#find_next_project - After timeframe filter count: #{base_query.count}"

      # Apply program filter if specified
      program_ids = Array(filters["ysws_program_ids"]).reject(&:blank?)
      if program_ids.present?
        base_query = base_query.where(ysws_program: { airtable_id: program_ids })
        Rails.logger.debug "SpotCheckSession#find_next_project - After program filter count: #{base_query.count}"
      end

      # Exclude already reviewed projects in this session
      reviewed_project_ids = spot_checks.pluck(:approved_project_id)
      if reviewed_project_ids.any?
        base_query = base_query.where.not(airtable_id: reviewed_project_ids)
        Rails.logger.debug "SpotCheckSession#find_next_project - After excluding reviewed projects count: #{base_query.count}"
      end

      # Apply sampling strategy
      case sampling_strategy
      when "random"
        base_query.order("RANDOM()").first
      when "highest_hours"
        Rails.logger.debug "SpotCheckSession#find_next_project - Projects by hours: #{base_query.pluck(:hours_spent, :airtable_id)}"
        next_project = base_query.order(hours_spent: :desc).first
        Rails.logger.debug "SpotCheckSession#find_next_project - Selected project: #{next_project&.inspect}"
        next_project
      end
    end
  end
end 