class RecreateYswsSpotChecks < ActiveRecord::Migration[8.0]
  def up
    # Create a temporary table to store existing data
    create_table :temp_spot_checks, id: false do |t|
      t.string :airtable_id, null: false
      t.string :approved_project_id, null: false
      t.integer :old_assessment, null: false
      t.text :notes, null: false
      t.string :reviewer_slack_id, null: false
      t.timestamps
    end

    # Copy existing data to temp table
    execute <<-SQL
      INSERT INTO temp_spot_checks 
      SELECT id as airtable_id, approved_project_id, assessment as old_assessment, notes, reviewer_slack_id, created_at, updated_at 
      FROM ysws_spot_checks;
    SQL

    # Drop the existing table
    remove_foreign_key :ysws_spot_checks, :ysws_approved_projects
    drop_table :ysws_spot_checks

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

    # Copy data back with converted assessment values
    execute <<-SQL
      INSERT INTO ysws_spot_checks (airtable_id, approved_project_id, assessment, notes, reviewer_slack_id, created_at, updated_at)
      SELECT 
        airtable_id,
        approved_project_id,
        CASE old_assessment
          WHEN 0 THEN 'red'
          WHEN 1 THEN 'yellow'
          WHEN 2 THEN 'green'
          ELSE 'red'
        END as assessment,
        notes,
        reviewer_slack_id,
        created_at,
        updated_at
      FROM temp_spot_checks;
    SQL

    # Drop temporary table
    drop_table :temp_spot_checks

    # Add foreign key and indexes
    add_foreign_key :ysws_spot_checks, :ysws_approved_projects, 
                   column: :approved_project_id,
                   primary_key: :airtable_id
    add_index :ysws_spot_checks, :approved_project_id
    add_index :ysws_spot_checks, :assessment
  end

  def down
    # Create a temporary table to store existing data
    create_table :temp_spot_checks, id: false do |t|
      t.string :airtable_id, null: false
      t.string :approved_project_id, null: false
      t.string :old_assessment, null: false
      t.text :notes, null: false
      t.string :reviewer_slack_id, null: false
      t.timestamps
    end

    # Copy existing data to temp table
    execute <<-SQL
      INSERT INTO temp_spot_checks 
      SELECT * FROM ysws_spot_checks;
    SQL

    # Drop and recreate the table with integer assessment
    drop_table :ysws_spot_checks

    create_table :ysws_spot_checks, id: false do |t|
      t.string :airtable_id, null: false, primary_key: true
      t.string :approved_project_id, null: false
      t.integer :assessment, null: false
      t.text :notes, null: false
      t.string :reviewer_slack_id, null: false
      t.timestamps
    end

    # Copy data back with converted assessment values
    execute <<-SQL
      INSERT INTO ysws_spot_checks (airtable_id, approved_project_id, assessment, notes, reviewer_slack_id, created_at, updated_at)
      SELECT 
        airtable_id,
        approved_project_id,
        CASE old_assessment
          WHEN 'red' THEN 0
          WHEN 'yellow' THEN 1
          WHEN 'green' THEN 2
          ELSE 0
        END as assessment,
        notes,
        reviewer_slack_id,
        created_at,
        updated_at
      FROM temp_spot_checks;
    SQL

    # Drop temporary table
    drop_table :temp_spot_checks

    add_foreign_key :ysws_spot_checks, :ysws_approved_projects,
                   column: :approved_project_id,
                   primary_key: :airtable_id
    add_index :ysws_spot_checks, :approved_project_id
    add_index :ysws_spot_checks, :assessment
  end
end
