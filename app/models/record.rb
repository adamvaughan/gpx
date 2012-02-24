class Record < ActiveRecord::Base
  belongs_to :best_distance_segment, :class_name => 'Segment'
  belongs_to :best_duration_segment, :class_name => 'Segment'

  def self.current
    Record.first || Record.create(:best_year_distance => 0, :best_month_distance => 0, :best_week_distance => 0, :best_year_duration => 0, :best_month_duration => 0, :best_week_duration => 0)
  end
end
