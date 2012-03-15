class AddWeekSegmentCountToReports < ActiveRecord::Migration
  def change
    change_table :reports do |t|
      t.integer :week_segment_count
    end
  end
end
