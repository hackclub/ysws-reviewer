class CreateYswsApprovedProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :ysws_approved_projects, id: false do |t|
      t.string :airtable_id, primary_key: true
      t.string :email
      t.string :referral_reason
      t.text :heard_about
      t.text :doing_well_feedback
      t.text :improvement_feedback
      t.string :age_when_approved
      t.string :playable_url
      t.string :code_url
      t.text :description
      t.string :github_username
      t.string :address_line1
      t.string :address_line2
      t.string :city
      t.string :state_province
      t.string :country
      t.string :postal_code
      t.date :birthday
      t.decimal :hours_spent, precision: 5, scale: 1
      t.decimal :override_hours_spent, precision: 5, scale: 1
      t.text :override_hours_spent_justification
      t.decimal :weighted_project_contribution, precision: 5, scale: 1
      t.datetime :approved_at
      t.string :first_name
      t.string :last_name
      t.decimal :weighted_project_contribution_per_author, precision: 5, scale: 1
      t.string :author_countries
      t.string :unique_countries
      t.string :archive_live_url
      t.string :archive_code_url
      t.datetime :archive_archived_at
      t.boolean :archive_trigger_rearchive
      t.boolean :archive_trigger_rearchive2
      t.string :hack_clubber_geocoded_country

      t.timestamps
    end

    add_index :ysws_approved_projects, :github_username
    add_index :ysws_approved_projects, :email
    add_index :ysws_approved_projects, :approved_at
    add_index :ysws_approved_projects, [:first_name, :last_name]
  end
end
