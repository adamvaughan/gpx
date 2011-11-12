object @points

attributes :latitude, :longitude, :elevation, :distance, :duration, :active_duration, :pace, :speed

node(:epoch_time) { |point| point.time.to_i }
