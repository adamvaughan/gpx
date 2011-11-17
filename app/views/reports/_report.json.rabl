object @report
attributes :id,
  :segment_count,
  :year_distance,
  :year_duration,
  :month_distance,
  :month_duration,
  :week_distance,
  :week_duration

node(:created_at) { |report| report.created_at.to_i }
node(:updated_at) { |report| report.updated_at.to_i }
