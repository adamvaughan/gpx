object @segment
attributes :id,
  :distance,
  :ascending_distance,
  :descending_distance,
  :flat_distance,
  :elevation_gain,
  :elevation_loss,
  :elevation_change,
  :maximum_elevation,
  :minimum_elevation,
  :duration,
  :active_duration,
  :ascending_duration,
  :descending_duration,
  :flat_duration,
  :average_pace,
  :average_ascending_pace,
  :average_descending_pace,
  :average_flat_pace,
  :average_speed,
  :average_ascending_speed,
  :average_descending_speed,
  :average_flat_speed,
  :maximum_speed,
  :average_heart_rate,
  :maximum_heart_rate

node(:href) { |segment| api_segment_url(segment) }
node(:points_href) { |segment| api_segment_points_url(segment) }
node(:start_time) { |segment| segment.start_time.to_i }
node(:created_at) { |segment| segment.created_at.to_i }
node(:updated_at) { |segment| segment.updated_at.to_i }
