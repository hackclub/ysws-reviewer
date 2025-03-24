class DropAndRecreateYswsSpotChecks < ActiveRecord::Migration[8.0]
  def up
    # Drop the existing table and its foreign key
    remove_foreign_key :ysws_spot_checks, :ysws_approved_projects rescue nil
    drop_table :ysws_spot_checks rescue nil

    # Create the new table with fields in logical order
    create_table :ysws_spot_checks, id: false do |t|
      # Primary key
      t.string :airtable_id, null: false, primary_key: true
      
      # Core relationships
      t.string :approved_project_id, null: false
      
      # Assessment data (using string enum)
      t.string :assessment, null: false
      t.text :notes, null: false
      
      # Reviewer info
      t.string :reviewer_slack_id, null: false
      
      t.timestamps
    end

    # Add foreign key and indexes
    add_foreign_key :ysws_spot_checks, :ysws_approved_projects, 
                   column: :approved_project_id,
                   primary_key: :airtable_id
    add_index :ysws_spot_checks, :approved_project_id
    add_index :ysws_spot_checks, :assessment
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
