module Gpx
  module Reports
    module ReportGenerator
      class << self
        # Creates the report for the current date.
        def create_current!
          segments = Segment.this_year
          report = Report.current
          update_year_totals(segments, report)
          update_month_totals(segments, report)
          update_week_totals(segments, report)
          report.save!
        end

        # Sets the report totals for the current year.
        def update_year_totals(segments, report)
          report.year_distance = 0
          report.year_duration = 0
          report.year_elevation_gain = 0
          report.year_segment_count = segments.count

          segments.each do |segment|
            report.year_distance += segment.distance
            report.year_duration += segment.active_duration
            report.year_elevation_gain += segment.elevation_gain
          end
        end

        # Sets the report totals for the current month.
        def update_month_totals(segments, report)
          current_month = Date.today.month
          report.month_distance = 0
          report.month_duration = 0
          report.month_elevation_gain = 0
          report.month_segment_count = 0

          segments.each do |segment|
            if segment.start_time.month == current_month
              report.month_distance += segment.distance
              report.month_duration += segment.active_duration
              report.month_elevation_gain += segment.elevation_gain
              report.month_segment_count += 1
            end
          end
        end

        # Sets the report totals for the current week.
        def update_week_totals(segments, report)
          current_week = Date.today.cweek
          report.week_distance = 0
          report.week_duration = 0
          report.week_elevation_gain = 0
          report.week_segment_count = 0

          segments.each do |segment|
            if segment.start_time.to_date.cweek == current_week
              report.week_distance += segment.distance
              report.week_duration += segment.active_duration
              report.week_elevation_gain += segment.elevation_gain
              report.week_segment_count += 1
            end
          end
        end
      end
    end
  end
end
