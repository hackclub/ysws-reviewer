class CreateYswsSpotChecks < ActiveRecord::Migration[8.0]
  def change
    create_table :ysws_spot_checks, id: false do |t|
      t.string :id, primary_key: true
      t.string :approved_project_id, null: false
      t.integer :assessment, null: false
      t.text :notes
      t.string :reviewer_name
      t.string :reviewer_slack_id
      t.string :reviewer_email

      t.timestamps
    end

    add_foreign_key :ysws_spot_checks, :ysws_approved_projects, 
                    column: :approved_project_id, 
                    primary_key: :airtable_id
    add_index :ysws_spot_checks, :approved_project_id
  end
end
