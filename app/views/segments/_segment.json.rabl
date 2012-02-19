object @segment
attributes :id,
  :name,
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
  :maximum_speed

node(:href) { |segment| segment_path(segment) }
node(:points_href) { |segment| segment_points_path(segment) }
node(:start_time) { |segment| segment.start_time.to_i }
node(:created_at) { |segment| segment.created_at.to_i }
node(:updated_at) { |segment| segment.updated_at.to_i }
