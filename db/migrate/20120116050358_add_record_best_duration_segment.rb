class AddRecordBestDurationSegment < ActiveRecord::Migration
  def change
    change_table :records do |t|
      t.references :best_duration_segment
    end
  end
end
