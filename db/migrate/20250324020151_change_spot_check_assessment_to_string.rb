class ChangeSpotCheckAssessmentToString < ActiveRecord::Migration[8.0]
  def up
    # Create a temporary column to store the string values
    add_column :ysws_spot_checks, :assessment_str, :string

    # Convert existing integer values to strings
    execute <<-SQL
      UPDATE ysws_spot_checks
      SET assessment_str = CASE assessment
        WHEN 0 THEN 'green'
        WHEN 1 THEN 'yellow'
        WHEN 2 THEN 'red'
      END;
    SQL

    # Remove the old integer column and rename the new string column
    remove_column :ysws_spot_checks, :assessment
    rename_column :ysws_spot_checks, :assessment_str, :assessment

    # Add NOT NULL constraint back
    change_column_null :ysws_spot_checks, :assessment, false
  end

  def down
    # Create a temporary column to store the integer values
    add_column :ysws_spot_checks, :assessment_int, :integer

    # Convert string values back to integers
    execute <<-SQL
      UPDATE ysws_spot_checks
      SET assessment_int = CASE assessment
        WHEN 'green' THEN 0
        WHEN 'yellow' THEN 1
        WHEN 'red' THEN 2
      END;
    SQL

    # Remove the string column and rename the integer column
    remove_column :ysws_spot_checks, :assessment
    rename_column :ysws_spot_checks, :assessment_int, :assessment

    # Add NOT NULL constraint back
    change_column_null :ysws_spot_checks, :assessment, false
  end
end
