object @ride
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

node(:href) { |ride| api_ride_url(ride) }
node(:points_href) { |ride| api_ride_points_url(ride) }
node(:start_time) { |ride| ride.start_time.to_i }
node(:created_at) { |ride| ride.created_at.to_i }
node(:updated_at) { |ride| ride.updated_at.to_i }
