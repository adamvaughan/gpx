object @points

attributes :latitude, :longitude, :elevation, :distance, :pace, :speed

node(:epoch_time) { |point| point.time.to_i }
node(:duration) { |point| point.duration }
