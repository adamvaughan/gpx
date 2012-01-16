class RenameRecordBestSegment < ActiveRecord::Migration
  def change
    rename_column :records, :best_segment_id, :best_distance_segment_id
  end
end
