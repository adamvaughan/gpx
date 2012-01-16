object @record
attributes :id,
  :best_year_distance,
  :best_year_duration,
  :best_month_distance,
  :best_month_duration,
  :best_week_distance,
  :best_week_duration

node(:best_segment_distance) { |record| record.best_distance_segment_id ? record.best_distance_segment.distance : 0 }
node(:best_segment_duration) { |record| record.best_duration_segment_id ? record.best_duration_segment.duration : 0 }
node(:created_at) { |record| record.created_at.to_i }
node(:updated_at) { |record| record.updated_at.to_i }
