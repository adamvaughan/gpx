object @point

attributes :latitude,
  :longitude,
  :elevation,
  :distance,
  :duration,
  :active_duration,
  :pace,
  :speed,
  :heart_rate,
  :cadence

node(:time) { |point| point.time.to_i }
node(:created_at) { |point| point.created_at.to_i }
