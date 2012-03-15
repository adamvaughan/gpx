class AddMonthSegmentCountToReports < ActiveRecord::Migration
  def change
    change_table :reports do |t|
      t.integer :month_segment_count
    end
  end
end
