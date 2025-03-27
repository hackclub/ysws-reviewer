class AddTimingToYswsSpotChecks < ActiveRecord::Migration[8.0]
  def change
    add_column :ysws_spot_checks, :start_time, :datetime
    add_column :ysws_spot_checks, :end_time, :datetime
    add_reference :ysws_spot_checks, :spot_check_session, null: true, foreign_key: { to_table: :ysws_spot_check_sessions }
  end
end
