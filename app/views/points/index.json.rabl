object @points

attributes :latitude, :longitude, :elevation

node(:epoch_time) { |point| point.time.to_i }
