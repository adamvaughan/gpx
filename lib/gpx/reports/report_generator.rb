module Gpx
  module Reports
    module ReportGenerator
      class << self
        # Creates the report for the current date.
        def create_current!
          rides = Ride.this_year
          report = Report.current
          update_year_totals(rides, report)
          update_month_totals(rides, report)
          update_week_totals(rides, report)
          report.save!
        end

        # Sets the report totals for the current year.
        def update_year_totals(rides, report)
          report.year_distance = 0
          report.year_duration = 0
          report.year_elevation_gain = 0
          report.year_ride_count = rides.count

          rides.each do |ride|
            report.year_distance += ride.distance
            report.year_duration += ride.active_duration
            report.year_elevation_gain += ride.elevation_gain
          end
        end

        # Sets the report totals for the current month.
        def update_month_totals(rides, report)
          current_month = Date.today.month
          report.month_distance = 0
          report.month_duration = 0
          report.month_elevation_gain = 0
          report.month_ride_count = 0

          rides.each do |ride|
            if ride.start_time.month == current_month
              report.month_distance += ride.distance
              report.month_duration += ride.active_duration
              report.month_elevation_gain += ride.elevation_gain
              report.month_ride_count += 1
            end
          end
        end

        # Sets the report totals for the current week.
        def update_week_totals(rides, report)
          current_week = Date.today.cweek
          report.week_distance = 0
          report.week_duration = 0
          report.week_elevation_gain = 0
          report.week_ride_count = 0

          rides.each do |ride|
            if ride.start_time.to_date.cweek == current_week
              report.week_distance += ride.distance
              report.week_duration += ride.active_duration
              report.week_elevation_gain += ride.elevation_gain
              report.week_ride_count += 1
            end
          end
        end
      end
    end
  end
end
