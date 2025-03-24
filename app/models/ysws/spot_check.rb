module Ysws
  class SpotCheck < ApplicationRecord
    self.primary_key = :airtable_id

    belongs_to :approved_project, class_name: 'Ysws::ApprovedProject', foreign_key: :approved_project_id, primary_key: :airtable_id

    validates :assessment, presence: true
    validates :notes, presence: true, if: :requires_notes?
    validates :reviewer_slack_id, presence: true
    
    # Skip airtable_id validation during creation
    validates :airtable_id, presence: true, on: :update
    
    # Use after_validation callback to create Airtable record only if validations pass
    # but before actually saving to the database
    after_validation :create_airtable_record, on: :create, if: -> { errors.empty? }

    enum :assessment, { red: 'red', yellow: 'yellow', green: 'green' }

    def requires_notes?
      %w[yellow red].include?(assessment)
    end

    def self.assessment_from_airtable(value)
      case value
      when 'Green - Looks Good!' then 'green'
      when "Yellow - Something's Wrong" then 'yellow'
      when 'Red - Remove Project' then 'red'
      else
        raise ArgumentError, "Unknown Airtable assessment value: #{value}"
      end
    end

    private

    def airtable_assessment_value
      case assessment
      when 'green' then 'Green - Looks Good!'
      when 'yellow' then 'Yellow - Something\'s Wrong'
      when 'red' then 'Red - Remove Project'
      end
    end

    def create_airtable_record
      table_id = Rails.application.credentials.airtable.ysws.table_id.spot_checks
      response = AirtableService.instance.create_record(
        table_id,
        {
          'Project' => [approved_project.airtable_id],
          'Assessment' => airtable_assessment_value,
          'Notes For YSWS Authors' => notes,
          'Reviewer Slack ID' => reviewer_slack_id
        }
      )

      if response['error']
        errors.add(:base, "Error creating Airtable record: #{response['error']}")
        throw(:abort)
      end

      self.airtable_id = response['id']
    end
  end
end
