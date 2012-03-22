class RenameSegmentsToRides < ActiveRecord::Migration
  def change
    rename_table :segments, :rides
    rename_column :points, :segment_id, :ride_id
    rename_column :reports, :week_segment_count, :week_ride_count
    rename_column :reports, :month_segment_count, :month_ride_count
    rename_column :reports, :year_segment_count, :year_ride_count
  end
end
