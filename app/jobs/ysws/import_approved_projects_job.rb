module Ysws
  class ImportApprovedProjectsJob < ApplicationJob
    queue_as :default

    def perform
      airtable = AirtableService.instance
      offset = nil

      Ysws::ApprovedProject.transaction do
        # Start with clean slate
        Ysws::ApprovedProject.delete_all

        # Process page by page
        loop do
          response = airtable.list_records(Rails.application.credentials.airtable.ysws.table_id.approved_projects, offset: offset)

          response["records"].each do |record|
            fields = sanitize_fields(record["fields"])
            Ysws::ApprovedProject.create!(
              airtable_id: record["id"],
              email: fields["Email"],
              referral_reason: fields["Referral Reason"],
              heard_about: fields["How did you hear about this?"],
              doing_well_feedback: fields["What are we doing well?"],
              improvement_feedback: fields["How can we improve?"],
              age_when_approved: fields["Age When Approved"],
              playable_url: fields["Playable URL"],
              code_url: fields["Code URL"],
              description: fields["Description"],
              github_username: fields["GitHub Username"],
              address_line1: fields["Address (Line 1)"],
              address_line2: fields["Address (Line 2)"],
              city: fields["City"],
              state_province: fields["State / Province"],
              country: fields["Country"],
              postal_code: fields["ZIP / Postal Code"],
              birthday: fields["Birthday"],
              hours_spent: fields["Hours Spent"],
              override_hours_spent: fields["Override Hours Spent"],
              override_hours_spent_justification: fields["Override Hours Spent Justification"],
              weighted_project_contribution: fields["YSWS–Weighted Project Contribution"],
              approved_at: fields["Approved At"],
              created_at: fields["Created"],
              first_name: fields["First Name"],
              last_name: fields["Last Name"],
              weighted_project_contribution_per_author: fields["YSWS–Weighted Project Contribution Per Author"],
              author_countries: fields["Author countries"],
              unique_countries: fields["Unique countries"],
              archive_live_url: fields["Archive - Live URL"],
              archive_code_url: fields["Archive - Code URL"],
              archive_archived_at: fields["Archive - Archived At"],
              archive_trigger_rearchive: fields["Archive - Trigger Rearchive"],
              archive_trigger_rearchive2: fields["Archive - Trigger Rearchive 2"],
              hack_clubber_geocoded_country: fields["Hack Clubber–Geocoded Country"]
            )
          end

          offset = response["offset"]
          break unless offset
        end
      end
    end

    private

    def sanitize_fields(fields)
      fields.transform_values do |value|
        case value
        when String
          value.delete("\u0000")  # Remove null bytes
        when Array
          value.map { |v| v.is_a?(String) ? v.delete("\u0000") : v }
        else
          value
        end
      end
    end
  end
end
