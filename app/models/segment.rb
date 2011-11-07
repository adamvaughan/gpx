class Segment < ActiveRecord::Base
  has_many :points

  validates :name, :presence => true

  # Compares two segments for order based on start time.
  def <=>(other)
    start_time <=> other.start_time
  end

  # Gets the starting time for the segment.
  #
  # Returns the time for the first point or nil if no points exist.
  def start_time
    return nil unless points.any?
    points.first.time
  end

  # Calculates the total distance traveled between points on a segment.
  #
  # Returns the distance traveled in meters.
  def distance
    point_pairs.inject(0) { |total, pair| total + distance_between(*pair) }
  end

  # Calculates the distance traveled between points while ascending on a
  # segment.
  #
  # Returns the distance traveled while ascending in meters.
  def ascending_distance
    ascending_point_pairs.inject(0) { |total, pair| total + distance_between(*pair) }
  end

  # Calculates the distance traveled between points while descending on a
  # segment.
  #
  # Returns the distance traveled while descending in meters.
  def descending_distance
    descending_point_pairs.inject(0) { |total, pair| total + distance_between(*pair) }
  end

  # Calculates the distance traveled between points with little to no
  # elevation change on a segment.
  #
  # Returns the distance traveled with no elevation change in meters.
  def flat_distance
    flat_point_pairs.inject(0) { |total, pair| total + distance_between(*pair) }
  end

  # Calculates the total positive elevation change between points on a
  # segment.
  #
  # Returns the elevation gained in meters.
  def elevation_gain
    ascending_point_pairs.inject(0) { |total, pair| total + elevation_between(*pair) }
  end

  # Calculates the total negative elevation change between points on a
  # segment.
  #
  # Returns the elevation lost in meters.
  def elevation_loss
    descending_point_pairs.inject(0) { |total, pair| total + elevation_between(*pair) } * -1
  end

  # Calculates the elevation change between points on a segment.
  #
  # Returns the elevation change in meters.
  def elevation_change
    elevation_gain - elevation_loss
  end

  # Calculates the time elapsed between points on a segment.
  #
  # Returns the duration in seconds.
  def duration
    return 0 if points.size < 2
    time_between(points.first, points.last)
  end

  # Calculates the time elapsed between points on a segment where the points
  # are actually moving. To be considered moving, the speed between to
  # points has to be over 0.5 m/s.
  #
  # Returns the active duration in seconds.
  def active_duration
    point_pairs.inject(0) { |total, pair| total + (speed_between(*pair) > 0.5 ? time_between(*pair) : 0) }
  end

  # Calculates the time elapsed between points while ascending on a segment.
  #
  # Returns the elapsed time while ascending in seconds.
  def ascending_duration
    ascending_point_pairs.inject(0) { |total, pair| total + time_between(*pair) }
  end

  # Calculates the time elapsed between points while descending on a
  # segment.
  #
  # Returns the elapsed time while descending in seconds.
  def descending_duration
    descending_point_pairs.inject(0) { |total, pair| total + time_between(*pair) }
  end

  # Calculates the time elapsed between points with little to no elevation
  # change on a segment.
  #
  # Returns the elapsed time with no elevation change in seconds.
  def flat_duration
    flat_point_pairs.inject(0) { |total, pair| total + time_between(*pair) }
  end

  # Calculates the average pace traveled between points on a segment.
  #
  # Returns the average pace in seconds per meter.
  def average_pace
    return 0 if points.empty?
    point_pairs.inject(0) { |total, pair| total + pace_between(*pair) } / points.size
  end

  # Calculates the average pace between points while ascending on a segment.
  #
  # Returns the average pace while ascending in seconds per meter.
  def average_ascending_pace
    count = 0

    total_pace = ascending_point_pairs.inject(0) do |total, pair|
      count += 1
      total + pace_between(*pair)
    end

    count == 0 ? 0 : total_pace / (count + 1)
  end

  # Calculates the average pace between points while descending on a
  # segment.
  #
  # Returns the average pace while descending in seconds per meter.
  def average_descending_pace
    count = 0

    total_pace = descending_point_pairs.inject(0) do |total, pair|
      count += 1
      total + pace_between(*pair)
    end

    count == 0 ? 0 : total_pace / (count + 1)
  end

  # Calculates the average pace between points with little to no elevation
  # change on a segment.
  #
  # Returns the average pace with no elevation change in seconds per meter.
  def average_flat_pace
    count = 0

    total_pace = flat_point_pairs.inject(0) do |total, pair|
      count += 1
      total + pace_between(*pair)
    end

    count == 0 ? 0 : total_pace / (count + 1)
  end

  # Calculates the average speed traveled between points on a segment.
  #
  # Returns the average speed in meters per second.
  def average_speed
    return 0 if points.empty?
    point_pairs.inject(0) { |total, pair| total + speed_between(*pair) } / points.size
  end

  # Calculates the average speed between points while ascending on a
  # segment.
  #
  # Returns the average speed while ascending in meters per second.
  def average_ascending_speed
    count = 0

    total_speed = ascending_point_pairs.inject(0) do |total, pair|
      count += 1
      total + speed_between(*pair)
    end

    count == 0 ? 0 : total_speed / (count + 1)
  end

  # Calculates the average speed between points while descending on a
  # segment.
  #
  # Returns the average speed while descending in meters per second.
  def average_descending_speed
    count = 0

    total_speed = descending_point_pairs.inject(0) do |total, pair|
      count += 1
      total + speed_between(*pair)
    end

    count == 0 ? 0 : total_speed / (count + 1)
  end

  # Calculates the average speed between points with little to no elevation
  # change on a segment.
  #
  # Returns the average speed with no elevation change in meters per second.
  def average_flat_speed
    count = 0

    total_speed = flat_point_pairs.inject(0) do |total, pair|
      count += 1
      total + speed_between(*pair)
    end

    count == 0 ? 0 : total_speed / (count + 1)
  end

  # Calculates the maximum speed traveled between points on a segment.
  #
  # Returns the maximum speed in meters per second.
  def maximum_speed
    return 0 if points.size < 2
    point_pairs.map { |pair| speed_between(*pair) }.max
  end

  private

  # Gathers pairs of adjacent points.
  #
  # If a block is given it is called once with each point pair.
  #
  # Otherwise, returns an array of the point pairs.
  def point_pairs
    pairs = []

    points.each_with_index do |point, index|
      if index < points.size - 1
        next_point = points[index + 1]

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
  def ascending_point_pairs
    pairs = []

    point_pairs do |point, next_point|
      if elevation_between(point, next_point) > 0.3
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
  def descending_point_pairs
    pairs = []

    point_pairs do |point, next_point|
      if elevation_between(next_point, point) > 0.3
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
  def flat_point_pairs
    pairs = []

    point_pairs do |point, next_point|
      if elevation_between(point, next_point).abs <= 0.3
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

  # average radius of the Earth, in meters
  EARTH_RADIUS = 6378137

  # Computes the distance traveled between two points as the shortest distance
  # between those two points.
  #
  # Returns the distance in meters.
  def haversine_distance(from_point, to_point)
    delta_latitude = degrees_to_radians(to_point.latitude - from_point.latitude)
    delta_longitude = degrees_to_radians(to_point.longitude - from_point.longitude)
    from_latitude = degrees_to_radians(from_point.latitude)
    to_latitude = degrees_to_radians(to_point.latitude)

    a = Math.sin(delta_latitude / 2) * Math.sin(delta_latitude / 2) +
        Math.sin(delta_longitude / 2) * Math.sin(delta_longitude / 2) * Math.cos(from_latitude) * Math.cos(to_latitude)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    EARTH_RADIUS * c
  end

  alias :distance_between :haversine_distance

  # Computes the speed the distance between two points was traveled at.
  #
  # Returns the speed in meters per second.
  def speed_between(start_point, end_point)
    distance_between(start_point, end_point) / time_between(start_point, end_point)
  end

  # Computes the pace the distance between two points was traveled at.
  #
  # Returns the pace in seconds per meter.
  def pace_between(start_point, end_point)
    time_between(start_point, end_point) / distance_between(start_point, end_point)
  end

  # Computes the time elapsed between two points.
  #
  # Returns the time in seconds.
  def time_between(start_point, end_point)
    end_point.time - start_point.time
  end

  # Computes the elevation change between two points.
  #
  # Returns the elevation change in meters.
  def elevation_between(start_point, end_point)
    end_point.elevation - start_point.elevation
  end
end
