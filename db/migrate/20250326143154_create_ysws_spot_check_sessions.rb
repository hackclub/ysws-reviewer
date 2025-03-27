class CreateYswsSpotCheckSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :ysws_spot_check_sessions do |t|
      t.jsonb :filters
      t.integer :sampling_strategy
      t.string :creator_slack_id
      t.string :creator_name
      t.string :creator_email
      t.string :creator_avatar_url
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
