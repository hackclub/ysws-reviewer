class RemoveNotNullConstraintFromSpotCheckNotes < ActiveRecord::Migration[8.0]
  def change
    change_column_null :ysws_spot_checks, :notes, true
  end
end
