object @record
attributes :id
attribute :best_year => :best_year_distance
attribute :best_month => :best_month_distance
attribute :best_week => :best_week_distance

node(:best_segment_distance) { |record| record.best_segment_id ? record.best_segment.distance : 0 }
node(:created_at) { |record| record.created_at.to_i }
node(:updated_at) { |record| record.updated_at.to_i }
