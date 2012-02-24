module Gpx
  module Statistics
    module SegmentStatistics
      class << self
        # Computes all statistics for a segment.
        def calculate(segment)
          segment.start_time = start_time(segment)
          segment.distance = distance(segment)
          segment.ascending_distance = ascending_distance(segment)
          segment.descending_distance = descending_distance(segment)
          segment.flat_distance = flat_distance(segment)
          segment.elevation_gain = elevation_gain(segment)
          segment.elevation_loss = elevation_loss(segment)
          segment.elevation_change = elevation_change(segment)
          segment.maximum_elevation = maximum_elevation(segment)
          segment.minimum_elevation = minimum_elevation(segment)
          segment.duration = duration(segment)
          segment.active_duration = active_duration(segment)
          segment.ascending_duration = ascending_duration(segment)
          segment.descending_duration = descending_duration(segment)
          segment.flat_duration = flat_duration(segment)
          segment.average_pace = average_pace(segment)
          segment.average_ascending_pace = average_ascending_pace(segment)
          segment.average_descending_pace = average_descending_pace(segment)
          segment.average_flat_pace = average_flat_pace(segment)
          segment.average_speed = average_speed(segment)
          segment.average_ascending_speed = average_ascending_speed(segment)
          segment.average_descending_speed = average_descending_speed(segment)
          segment.average_flat_speed = average_flat_speed(segment)
          segment.maximum_speed = maximum_speed(segment)
          segment.average_heart_rate = average_heart_rate(segment)
          segment.maximum_heart_rate = maximum_heart_rate(segment)
        end

        protected

        # Gets the starting time for the segment.
        #
        # Returns the time for the first point or nil if no points exist.
        def start_time(segment)
          return nil unless segment.points.any?
          segment.points.first.time
        end

        # Calculates the total distance traveled between points on a segment.
        #
        # Returns the distance traveled in meters.
        def distance(segment)
          point_pairs(segment).inject(0) do |total, pair|
            pair.first.distance = total
            pair.last.distance = total + distance_between(*pair)
          end
        end

        # Calculates the distance traveled between points while ascending on a
        # segment.
        #
        # Returns the distance traveled while ascending in meters.
        def ascending_distance(segment)
          ascending_point_pairs(segment).inject(0) { |total, pair| total + distance_between(*pair) }
        end

        # Calculates the distance traveled between points while descending on a
        # segment.
        #
        # Returns the distance traveled while descending in meters.
        def descending_distance(segment)
          descending_point_pairs(segment).inject(0) { |total, pair| total + distance_between(*pair) }
        end

        # Calculates the distance traveled between points with little to no
        # elevation change on a segment.
        #
        # Returns the distance traveled with no elevation change in meters.
        def flat_distance(segment)
          flat_point_pairs(segment).inject(0) { |total, pair| total + distance_between(*pair) }
        end

        # Calculates the total positive elevation change between points on a
        # segment.
        #
        # Returns the elevation gained in meters.
        def elevation_gain(segment)
          ascending_point_pairs(segment).inject(0) { |total, pair| total + elevation_between(*pair) }
        end

        # Calculates the total negative elevation change between points on a
        # segment.
        #
        # Returns the elevation lost in meters.
        def elevation_loss(segment)
          descending_point_pairs(segment).inject(0) { |total, pair| total + elevation_between(*pair) } * -1
        end

        # Calculates the elevation change between points on a segment.
        #
        # Returns the elevation change in meters.
        def elevation_change(segment)
          maximum_elevation(segment) - minimum_elevation(segment)
        end

        # Calculates the maximum elevation reached on a segment.
        #
        # Returns the maximum elevation in meters.
        def maximum_elevation(segment)
          segment.points.map(&:elevation).max || 0
        end

        # Calculates the minimum elevation reached on a segment.
        #
        # Returns the minimum elevation in meters.
        def minimum_elevation(segment)
          segment.points.map(&:elevation).min || 0
        end

        # Calculates the time elapsed between points on a segment.
        #
        # Returns the duration in seconds.
        def duration(segment)
          if segment.points.size < 2
            segment.points.each { |point| point.duration = 0 }
            return 0
          end

          point_pairs(segment).inject(0) do |total, pair|
            pair.first.duration = total
            pair.last.duration = total + time_between(*pair)
          end
        end

        # Calculates the time elapsed between points on a segment where the points
        # are actually moving. To be considered moving, the speed between to
        # points has to be over 0.5 m/s.
        #
        # Returns the active duration in seconds.
        def active_duration(segment)
          if segment.points.size < 2
            segment.points.each { |point| point.active_duration = 0 }
            return 0
          end

          segment.points.first.active_duration = 0

          point_pairs(segment).inject(0) do |total, pair|
            if active_between?(*pair)
              pair.last.active_duration = total + time_between(*pair)
            else
              pair.last.active_duration = 0
              total
            end
          end
        end

        # Calculates the time elapsed between points while ascending on a segment.
        #
        # Returns the elapsed time while ascending in seconds.
        def ascending_duration(segment)
          point_pairs(segment).inject(0) do |total, pair|
            if active_between?(*pair) && ascending_between?(*pair)
              total + time_between(*pair)
            else
              total
            end
          end
        end

        # Calculates the time elapsed between points while descending on a
        # segment.
        #
        # Returns the elapsed time while descending in seconds.
        def descending_duration(segment)
          point_pairs(segment).inject(0) do |total, pair|
            if active_between?(*pair) && descending_between?(*pair)
              total + time_between(*pair)
            else
              total
            end
          end
        end

        # Calculates the time elapsed between points with little to no elevation
        # change on a segment.
        #
        # Returns the elapsed time with no elevation change in seconds.
        def flat_duration(segment)
          point_pairs(segment).inject(0) do |total, pair|
            if active_between?(*pair) && flat_between?(*pair)
              total + time_between(*pair)
            else
              total
            end
          end
        end

        # Calculates the average pace traveled between points on a segment. Only active periods are considered.
        #
        # Returns the average pace in seconds per meter.
        def average_pace(segment)
          if segment.points.size < 2
            segment.points.each { |point| point.pace = 0 }
            return 0
          end

          segment.points.first.pace = 0

          point_pairs(segment).each do |pair|
            pair.last.pace = pace_between(*pair)
          end

          active_duration(segment) / distance(segment)
        end

        # Calculates the average pace between points while ascending on a segment.
        #
        # Returns the average pace while ascending in seconds per meter.
        def average_ascending_pace(segment)
          ascending_duration(segment) / ascending_distance(segment)
        end

        # Calculates the average pace between points while descending on a
        # segment.
        #
        # Returns the average pace while descending in seconds per meter.
        def average_descending_pace(segment)
          descending_duration(segment) / descending_distance(segment)
        end

        # Calculates the average pace between points with little to no elevation
        # change on a segment.
        #
        # Returns the average pace with no elevation change in seconds per meter.
        def average_flat_pace(segment)
          flat_duration(segment) / flat_distance(segment)
        end

        # Calculates the average speed traveled between points on a segment. Only active periods are considered.
        #
        # Returns the average speed in meters per second.
        def average_speed(segment)
          if segment.points.size < 2
            segment.points.each { |point| point.speed = 0 }
            return 0
          end

          segment.points.first.speed = 0

          point_pairs(segment).each do |pair|
            pair.last.speed = speed_between(*pair)
          end

          distance(segment) / active_duration(segment)
        end

        # Calculates the average speed between points while ascending on a
        # segment.
        #
        # Returns the average speed while ascending in meters per second.
        def average_ascending_speed(segment)
          ascending_distance(segment) / ascending_duration(segment)
        end

        # Calculates the average speed between points while descending on a
        # segment.
        #
        # Returns the average speed while descending in meters per second.
        def average_descending_speed(segment)
          descending_distance(segment) / descending_duration(segment)
        end

        # Calculates the average speed between points with little to no elevation
        # change on a segment.
        #
        # Returns the average speed with no elevation change in meters per second.
        def average_flat_speed(segment)
          flat_distance(segment) / flat_duration(segment)
        end

        # Calculates the maximum speed traveled between points on a segment.
        #
        # Returns the maximum speed in meters per second.
        def maximum_speed(segment)
          return 0 if segment.points.size < 2
          point_pairs(segment).map { |pair| speed_between(*pair) }.max
        end

        # Calculates the average heart rate between points on a segment.
        #
        # Returns the average heart rate in beats per minute.
        def average_heart_rate(segment)
          return 0 if segment.points.size == 0
          segment.points.map(&:heart_rate).sum / segment.points.count
        end

        # Calculates the maximum heart rate between two points on a segment.
        #
        # Returns the maximum heart rate in beats per minute.
        def maximum_heart_rate(segment)
          return 0 if segment.points.size == 0
          segment.points.map(&:heart_rate).max
        end

        private

        # Gathers pairs of adjacent points.
        #
        # If a block is given it is called once with each point pair.
        #
        # Otherwise, returns an array of the point pairs.
        def point_pairs(segment)
          pairs = []

          segment.points.each_with_index do |point, index|
            if index < segment.points.size - 1
              next_point = segment.points[index + 1]

              if block_given?
                yield(point, next_point)
              else
                pairs << [point, next_point]
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
        def ascending_point_pairs(segment)
          pairs = []

          point_pairs(segment) do |point, next_point|
            if ascending_between?(point, next_point)
              if block_given?
                yield(point, next_point)
              else
                pairs << [point, next_point]
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
        def descending_point_pairs(segment)
          pairs = []

          point_pairs(segment) do |point, next_point|
            if descending_between?(point, next_point)
              if block_given?
                yield(point, next_point)
              else
                pairs << [point, next_point]
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
        def flat_point_pairs(segment)
          pairs = []

          point_pairs(segment) do |point, next_point|
            if active_between?(point, next_point) && flat_between?(point, next_point)
              if block_given?
                yield(point, next_point)
              else
                pairs << [point, next_point]
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
