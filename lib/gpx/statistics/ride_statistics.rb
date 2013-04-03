module Gpx
  module Statistics
    module RideStatistics
      class << self
        # Computes all statistics for a ride.
        def calculate(ride)
          ride.start_time = start_time(ride)
          ride.distance = distance(ride)
          ride.ascending_distance = ascending_distance(ride)
          ride.descending_distance = descending_distance(ride)
          ride.flat_distance = flat_distance(ride)
          ride.elevation_gain = elevation_gain(ride)
          ride.elevation_loss = elevation_loss(ride)
          ride.elevation_change = elevation_change(ride)
          ride.maximum_elevation = maximum_elevation(ride)
          ride.minimum_elevation = minimum_elevation(ride)
          ride.duration = duration(ride)
          ride.active_duration = active_duration(ride)
          ride.ascending_duration = ascending_duration(ride)
          ride.descending_duration = descending_duration(ride)
          ride.flat_duration = flat_duration(ride)
          ride.average_pace = average_pace(ride)
          ride.average_ascending_pace = average_ascending_pace(ride)
          ride.average_descending_pace = average_descending_pace(ride)
          ride.average_flat_pace = average_flat_pace(ride)
          ride.average_speed = average_speed(ride)
          ride.average_ascending_speed = average_ascending_speed(ride)
          ride.average_descending_speed = average_descending_speed(ride)
          ride.average_flat_speed = average_flat_speed(ride)
          ride.maximum_speed = maximum_speed(ride)
          ride.average_heart_rate = average_heart_rate(ride)
          ride.maximum_heart_rate = maximum_heart_rate(ride)
          ride.average_cadence = average_cadence(ride)
        end

        # Computes all statistics for a ride and saves the calculations.
        def calculate!(ride)
          calculate(ride)
          ride.save!
          ride.points.each { |point| point.save! }
        end

        # Gets the starting time for the ride.
        #
        # Returns the time for the first point or nil if no points exist.
        def start_time(ride)
          return nil unless ride.points.any?
          ride.points.first.time
        end

        # Calculates the total distance traveled between points on a ride.
        #
        # Returns the distance traveled in meters.
        def distance(ride)
          point_pairs(ride).inject(0) do |total, pair|
            pair.first.distance = total
            pair.last.distance = total + distance_between(*pair)
          end
        end

        # Calculates the distance traveled between points while ascending on a
        # ride.
        #
        # Returns the distance traveled while ascending in meters.
        def ascending_distance(ride)
          ascending_point_pairs(ride).inject(0) { |total, pair| total + distance_between(*pair) }
        end

        # Calculates the distance traveled between points while descending on a
        # ride.
        #
        # Returns the distance traveled while descending in meters.
        def descending_distance(ride)
          descending_point_pairs(ride).inject(0) { |total, pair| total + distance_between(*pair) }
        end

        # Calculates the distance traveled between points with little to no
        # elevation change on a ride.
        #
        # Returns the distance traveled with no elevation change in meters.
        def flat_distance(ride)
          flat_point_pairs(ride).inject(0) { |total, pair| total + distance_between(*pair) }
        end

        # Calculates the total positive elevation change between points on a
        # ride.
        #
        # Returns the elevation gained in meters.
        def elevation_gain(ride)
          ascending_point_pairs(ride).inject(0) { |total, pair| total + elevation_between(*pair) }
        end

        # Calculates the total negative elevation change between points on a
        # ride.
        #
        # Returns the elevation lost in meters.
        def elevation_loss(ride)
          descending_point_pairs(ride).inject(0) { |total, pair| total + elevation_between(*pair) } * -1
        end

        # Calculates the elevation change between points on a ride.
        #
        # Returns the elevation change in meters.
        def elevation_change(ride)
          maximum_elevation(ride) - minimum_elevation(ride)
        end

        # Calculates the maximum elevation reached on a ride.
        #
        # Returns the maximum elevation in meters.
        def maximum_elevation(ride)
          ride.points.map(&:elevation).max || 0
        end

        # Calculates the minimum elevation reached on a ride.
        #
        # Returns the minimum elevation in meters.
        def minimum_elevation(ride)
          ride.points.map(&:elevation).min || 0
        end

        # Calculates the time elapsed between points on a ride.
        #
        # Returns the duration in seconds.
        def duration(ride)
          if ride.points.size < 2
            ride.points.each { |point| point.duration = 0 }
            return 0
          end

          point_pairs(ride).inject(0) do |total, pair|
            pair.first.duration = total
            pair.last.duration = total + time_between(*pair)
          end
        end

        # Calculates the time elapsed between points on a ride where the points
        # are actually moving. To be considered moving, the speed between to
        # points has to be over 0.5 m/s.
        #
        # Returns the active duration in seconds.
        def active_duration(ride)
          if ride.points.size < 2
            ride.points.each { |point| point.active_duration = 0 }
            return 0
          end

          ride.points.first.active_duration = 0

          point_pairs(ride).inject(0) do |total, pair|
            if active_between?(*pair)
              pair.last.active_duration = total + time_between(*pair)
            else
              pair.last.active_duration = 0
              total
            end
          end
        end

        # Calculates the time elapsed between points while ascending on a ride.
        #
        # Returns the elapsed time while ascending in seconds.
        def ascending_duration(ride)
          point_pairs(ride).inject(0) do |total, pair|
            if active_between?(*pair) && ascending_between?(*pair)
              total + time_between(*pair)
            else
              total
            end
          end
        end

        # Calculates the time elapsed between points while descending on a
        # ride.
        #
        # Returns the elapsed time while descending in seconds.
        def descending_duration(ride)
          point_pairs(ride).inject(0) do |total, pair|
            if active_between?(*pair) && descending_between?(*pair)
              total + time_between(*pair)
            else
              total
            end
          end
        end

        # Calculates the time elapsed between points with little to no elevation
        # change on a ride.
        #
        # Returns the elapsed time with no elevation change in seconds.
        def flat_duration(ride)
          point_pairs(ride).inject(0) do |total, pair|
            if active_between?(*pair) && flat_between?(*pair)
              total + time_between(*pair)
            else
              total
            end
          end
        end

        # Calculates the average pace traveled between points on a ride. Only active periods are considered.
        #
        # Returns the average pace in seconds per meter.
        def average_pace(ride)
          if ride.points.size < 2
            ride.points.each { |point| point.pace = 0 }
            return 0
          end

          ride.points.first.pace = 0

          point_pairs(ride).each do |pair|
            pair.last.pace = pace_between(*pair)
          end

          distance = distance(ride)
          return 0 if distance == 0
          active_duration(ride) / distance
        end

        # Calculates the average pace between points while ascending on a ride.
        #
        # Returns the average pace while ascending in seconds per meter.
        def average_ascending_pace(ride)
          distance = ascending_distance(ride)
          return 0 if distance == 0
          ascending_duration(ride) / distance
        end

        # Calculates the average pace between points while descending on a
        # ride.
        #
        # Returns the average pace while descending in seconds per meter.
        def average_descending_pace(ride)
          distance = descending_distance(ride)
          return 0 if distance == 0
          descending_duration(ride) / distance
        end

        # Calculates the average pace between points with little to no elevation
        # change on a ride.
        #
        # Returns the average pace with no elevation change in seconds per meter.
        def average_flat_pace(ride)
          distance = flat_distance(ride)
          return 0 if distance == 0
          flat_duration(ride) / distance
        end

        # Calculates the average speed traveled between points on a ride. Only
        # active periods are considered.
        #
        # Returns the average speed in meters per second.
        def average_speed(ride)
          if ride.points.size < 2
            ride.points.each { |point| point.speed = 0 }
            return 0
          end

          ride.points.first.speed = 0

          point_pairs(ride).each do |pair|
            pair.last.speed = speed_between(*pair)
          end

          duration = active_duration(ride)
          return 0 if duration == 0
          distance(ride) / duration
        end

        # Calculates the average speed between points while ascending on a
        # ride.
        #
        # Returns the average speed while ascending in meters per second.
        def average_ascending_speed(ride)
          duration = ascending_duration(ride)
          return 0 if duration == 0
          ascending_distance(ride) / duration
        end

        # Calculates the average speed between points while descending on a
        # ride.
        #
        # Returns the average speed while descending in meters per second.
        def average_descending_speed(ride)
          duration = descending_duration(ride)
          return 0 if duration == 0
          descending_distance(ride) / duration
        end

        # Calculates the average speed between points with little to no elevation
        # change on a ride.
        #
        # Returns the average speed with no elevation change in meters per second.
        def average_flat_speed(ride)
          duration = flat_duration(ride)
          return 0 if duration == 0
          flat_distance(ride) / duration
        end

        # Calculates the maximum speed traveled between points on a ride.
        #
        # Returns the maximum speed in meters per second.
        def maximum_speed(ride)
          return 0 if ride.points.size < 2
          point_pairs(ride).map { |pair| speed_between(*pair) }.max
        end

        # Calculates the average heart rate between points on a ride.
        #
        # Returns the average heart rate in beats per minute.
        def average_heart_rate(ride)
          points = ride.points.reject { |point| point.heart_rate.nil? }
          return nil if points.size == 0
          points.map(&:heart_rate).sum / points.count.to_f
        end

        # Calculates the maximum heart rate between two points on a ride.
        #
        # Returns the maximum heart rate in beats per minute.
        def maximum_heart_rate(ride)
          points = ride.points.reject { |point| point.heart_rate.nil? }
          return nil if points.size == 0
          points.map(&:heart_rate).max
        end

        # Calculates the average cadence between points on a ride.
        #
        # Returns the average cadence in revolutions per minute.
        def average_cadence(ride)
          points = ride.points.reject { |point| point.cadence.nil? }
          return nil if points.size == 0
          points.map(&:cadence).sum / points.count.to_f
        end

        private

        # Gathers pairs of adjacent points.
        #
        # If a block is given it is called once with each point pair.
        #
        # Otherwise, returns an array of the point pairs.
        def point_pairs(ride)
          pairs = []

          ride.points.each_with_index do |point, index|
            if index < ride.points.size - 1
              pair = [point, ride.points[index + 1]]

              if block_given?
                yield pair
              else
                pairs << pair
              end
            end
          end

          pairs unless block_given?
        end

        # Gathers pairs of adjacent ascending points.
        #
        # If a block is given it is called once with each point pair.
        #
        # Otherwise, returns an array of the point pairs.
        def ascending_point_pairs(ride)
          pairs = []

          point_pairs(ride) do |pair|
            if ascending_between?(*pair)
              if block_given?
                yield pair
              else
                pairs << pair
              end
            end
          end

          pairs unless block_given?
        end

        # Gathers pairs of adjacent descending points.
        #
        # If a block is given it is called once with each point pair.
        #
        # Otherwise, returns an array of the point pairs.
        def descending_point_pairs(ride)
          pairs = []

          point_pairs(ride) do |pair|
            if descending_between?(*pair)
              if block_given?
                yield pair
              else
                pairs << pair
              end
            end
          end

          pairs unless block_given?
        end

        # Gathers pairs of adjacent points with little to no elevation change.
        #
        # If a block is given it is called once with each point pair.
        #
        # Otherwise, returns an enumerator for the point pairs.
        def flat_point_pairs(ride)
          pairs = []

          point_pairs(ride) do |pair|
            if active_between?(*pair) && flat_between?(*pair)
              if block_given?
                yield pair
              else
                pairs << pair
              end
            end
          end

          pairs unless block_given?
        end

        DEG_TO_RAD = Math::PI / 180

        # Converts degrees to radians.
        #
        # Returns the value in radians.
        def degrees_to_radians(degrees)
          degrees * DEG_TO_RAD
        end

        # radius of the Earth at the equator
        EARTH_EQUATORIAL_RADIUS = 6378137.0

        # radius of the Earth at the poles
        EARTH_POLAR_RADIUS = 6356752.3

        # Computes the radius of the earth at a given point.
        #
        # See http://en.wikipedia.org/wiki/Earth_radius#Radii_with_location_dependence
        #
        # Returns the radius in meters
        def earth_radius(point)
          a = EARTH_EQUATORIAL_RADIUS
          b = EARTH_POLAR_RADIUS
          latitude = point.latitude

          Math.sqrt(((a**2 * Math.cos(latitude))**2 + (b**2 * Math.sin(latitude))**2) / ((a * Math.cos(latitude))**2 + (b * Math.sin(latitude))**2))
        end

        # Computes the distance traveled between two points as the shortest distance
        # between those two points.
        #
        # See http://en.wikipedia.org/wiki/Haversine_formula
        #
        # Returns the distance in meters.
        def haversine_distance(from_point, to_point)
          return 0 unless from_point.latitude && from_point.longitude && to_point.latitude && to_point.longitude

          delta_latitude = degrees_to_radians(to_point.latitude - from_point.latitude)
          delta_longitude = degrees_to_radians(to_point.longitude - from_point.longitude)
          from_latitude = degrees_to_radians(from_point.latitude)
          to_latitude = degrees_to_radians(to_point.latitude)

          a = Math.sin(delta_latitude / 2) * Math.sin(delta_latitude / 2) +
              Math.sin(delta_longitude / 2) * Math.sin(delta_longitude / 2) * Math.cos(from_latitude) * Math.cos(to_latitude)
          c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
          earth_radius(from_point) * c
        end

        alias :distance_between :haversine_distance

        # Computes the speed the distance between two points was traveled at.
        #
        # Returns the speed in meters per second.
        def speed_between(start_point, end_point)
          time = time_between(start_point, end_point)
          return 0 if time == 0

          distance = distance_between(start_point, end_point)
          return 0 if distance == 0

          distance / time
        end

        # Computes the pace the distance between two points was traveled at.
        #
        # Returns the pace in seconds per meter.
        def pace_between(start_point, end_point)
          return 0 unless active_between?(start_point, end_point)

          time = time_between(start_point, end_point)
          return 0 if time == 0

          distance = distance_between(start_point, end_point)
          return 0 if distance == 0

          time / distance
        end

        # Computes the time elapsed between two points.
        #
        # Returns the time in seconds.
        def time_between(start_point, end_point)
          return 0 unless start_point.time && end_point.time
          end_point.time - start_point.time
        end

        # Computes the elevation change between two points.
        #
        # Returns the elevation change in meters.
        def elevation_between(start_point, end_point)
          return 0 unless start_point.elevation && end_point.elevation
          end_point.elevation - start_point.elevation
        end

        # Determines if there is activity between two points.
        #
        # Returns true if there is activity; otherwise, false.
        def active_between?(start_point, end_point)
          speed_between(start_point, end_point) > 0.5
        end

        # Determins if elevation change is positive between two points.
        #
        # Returns true if there is elevation gain; otherwise, false.
        def ascending_between?(start_point, end_point)
          (elevation_between(start_point, end_point) / distance_between(start_point, end_point)) > 0.003
        end

        # Determins if elevation change is negative between two points.
        #
        # Returns true if there is elevation loss; otherwise, false.
        def descending_between?(start_point, end_point)
          (elevation_between(end_point, start_point) / distance_between(start_point, end_point)) > 0.003
        end

        # Determins if there is no elevation change between two points.
        #
        # Returns true if there is no elevation change; otherwise, false.
        def flat_between?(start_point, end_point)
          (elevation_between(start_point, end_point) / distance_between(start_point, end_point)).abs <= 0.003
        end
      end
    end
  end
end
