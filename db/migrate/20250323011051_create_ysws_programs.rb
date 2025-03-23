class CreateYswsPrograms < ActiveRecord::Migration[8.0]
  def change
    create_table :ysws_programs, id: false do |t|
      t.string :airtable_id, primary_key: true
      t.string :name
      t.decimal :average_hours_per_grant, precision: 10, scale: 1
      t.decimal :nps_score, precision: 5, scale: 2
      t.integer :nps_median_estimated_hours
      t.string :icon_cdn_link

      t.timestamps
    end

    # Add reference to approved projects
    add_reference :ysws_approved_projects, :ysws_program, 
                 type: :string, 
                 foreign_key: { to_table: :ysws_programs, primary_key: :airtable_id }, 
                 index: true
  end
end
