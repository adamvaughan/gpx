class SegmentDecorator < ApplicationDecorator
  decorates :segment

  def start_time
    segment.start_time.strftime('%-m/%-d/%y %-I:%M:%S %P')
  end

  def distance
    format_number(meters_to_miles(segment.distance))
  end

  def ascending_distance
    format_number(meters_to_miles(segment.ascending_distance))
  end

  def descending_distance
    format_number(meters_to_miles(segment.descending_distance))
  end

  def flat_distance
    format_number(meters_to_miles(segment.flat_distance))
  end

  def elevation_gain
    format_number(meters_to_feet(segment.elevation_gain))
  end

  def elevation_loss
    format_number(meters_to_feet(segment.elevation_loss))
  end

  def elevation_change
    format_number(meters_to_feet(segment.elevation_change))
  end

  def duration
    format_time(segment.duration)
  end

  def active_duration
    format_time(segment.active_duration)
  end

  def ascending_duration
    format_time(segment.ascending_duration)
  end

  def descending_duration
    format_time(segment.descending_duration)
  end

  def flat_duration
    format_time(segment.flat_duration)
  end

  def average_pace
    format_time(seconds_per_meter_to_seconds_per_mile(segment.average_pace))
  end

  def average_ascending_pace
    format_time(seconds_per_meter_to_seconds_per_mile(segment.average_ascending_pace))
  end

  def average_descending_pace
    format_time(seconds_per_meter_to_seconds_per_mile(segment.average_descending_pace))
  end

  def average_flat_pace
    format_time(seconds_per_meter_to_seconds_per_mile(segment.average_flat_pace))
  end

  def average_speed
    format_number(meters_per_second_to_miles_per_hour(segment.average_speed))
  end

  def average_ascending_speed
    format_number(meters_per_second_to_miles_per_hour(segment.average_ascending_speed))
  end

  def average_descending_speed
    format_number(meters_per_second_to_miles_per_hour(segment.average_descending_speed))
  end

  def average_flat_speed
    format_number(meters_per_second_to_miles_per_hour(segment.average_flat_speed))
  end

  def maximum_speed
    format_number(meters_per_second_to_miles_per_hour(segment.maximum_speed))
  end

  private

  def format_number(number)
    '%.2f' % number
  end

  def meters_to_feet(meters)
    meters * 3.2808399
  end

  def feet_to_miles(feet)
    feet / 5280
  end

  def meters_to_miles(meters)
    feet_to_miles(meters_to_feet(meters))
  end

  def format_time(seconds)
    hours = 0
    minutes = 0

    if seconds > 3600
      hours = (seconds / 3600).floor
      seconds = seconds % 3600
    end

    if seconds > 60
      minutes = (seconds / 60).floor
      seconds = seconds % 60
    end

    "#{hours}:#{'%02d' % minutes}:#{'%02d' % seconds.floor}"
  end

  def meters_per_second_to_miles_per_hour(meters_per_second)
    meters_per_second * 2.23693629
  end

  def seconds_per_meter_to_seconds_per_mile(seconds_per_meter)
    seconds_per_meter * 1609.344
  end
end
