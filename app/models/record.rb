class Record < ActiveRecord::Base
  belongs_to :best_distance_segment, :class_name => 'Segment'
  belongs_to :best_duration_segment, :class_name => 'Segment'

  def self.current
    Record.first || Record.create(:best_year => 0, :best_month => 0, :best_week => 0)
  end
end
