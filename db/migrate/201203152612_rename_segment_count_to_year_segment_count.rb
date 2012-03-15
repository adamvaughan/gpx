class RenameSegmentCountToYearSegmentCount < ActiveRecord::Migration
  def change
    rename_column :reports, :segment_count, :year_segment_count
  end
end
