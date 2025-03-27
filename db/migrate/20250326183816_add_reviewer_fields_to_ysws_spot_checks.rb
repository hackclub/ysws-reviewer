class AddReviewerFieldsToYswsSpotChecks < ActiveRecord::Migration[8.0]
  def change
    add_column :ysws_spot_checks, :reviewer_name, :string, null: false, default: ''
    add_column :ysws_spot_checks, :reviewer_email, :string, null: false, default: ''
    add_column :ysws_spot_checks, :reviewer_avatar_url, :string, null: false, default: ''
  end
end
