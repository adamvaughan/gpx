module Gpx
  module Records
    module RecordGenerator
      class << self
        # Updates the record attributes.
        def create_current!
          record = Record.current
          update_best_segment(record)
          update_best_year(record)
          update_best_month(record)
          update_best_week(record)
          record.save!
        end

        # Sets the best segment records.
        def update_best_segment(record)
          update_best_segment_distance(record)
          update_best_segment_duration(record)
        end

        # Sets the best segment distance record.
        def update_best_segment_distance(record)
          segment = Segment.unscoped.order('distance DESC').first

          if segment
            record.best_distance_segment_id = segment.id unless record.best_distance_segment_id == segment.id
          else
            record.best_distance_segment = 0
          end
        end

        # Sets the best segment duration record.
        def update_best_segment_duration(record)
          segment = Segment.unscoped.order('duration DESC').first

          if segment
            record.best_duration_segment_id = segment.id unless record.best_duration_segment_id == segment.id
          else
            record.best_duration_segment = 0
          end
        end

        # Sets the best year records.
        def update_best_year(record)
          update_best_year_distance(record)
          update_best_year_duration(record)
        end

        # Sets the best year distance record.
        def update_best_year_distance(record)
          if mysql?
            segment = Segment.find_by_sql('SELECT SUM(distance) AS distance FROM segments GROUP BY date_format(start_time, "%Y") ORDER BY distance DESC').first
          else
            segment = Segment.find_by_sql('SELECT SUM(distance) AS distance FROM segments GROUP BY strftime("%Y", start_time) ORDER BY distance DESC').first
          end

          record.best_year_distance = segment.distance || 0
        end

        # Sets the best year duration record.
        def update_best_year_duration(record)
          if mysql?
            segment = Segment.find_by_sql('SELECT SUM(duration) AS duration FROM segments GROUP BY date_format(start_time, "%Y") ORDER BY duration DESC').first
          else
            segment = Segment.find_by_sql('SELECT SUM(duration) AS duration FROM segments GROUP BY strftime("%Y", start_time) ORDER BY duration DESC').first
          end

          record.best_year_duration = segment.duration || 0
        end

        # Sets the best month records.
        def update_best_month(record)
          update_best_month_distance(record)
          update_best_month_duration(record)
        end

        # Sets the best month distance record.
        def update_best_month_distance(record)
          if mysql?
            segment = Segment.find_by_sql('SELECT SUM(distance) AS distance FROM segments GROUP BY date_format(start_time, "%Y %m") ORDER BY distance DESC').first
          else
            segment = Segment.find_by_sql('SELECT SUM(distance) AS distance FROM segments GROUP BY strftime("%Y %m", start_time) ORDER BY distance DESC').first
          end

          record.best_month_distance = segment.distance || 0
        end

        # Sets the best month duration record.
        def update_best_month_duration(record)
          if mysql?
            segment = Segment.find_by_sql('SELECT SUM(duration) AS duration FROM segments GROUP BY date_format(start_time, "%Y %m") ORDER BY duration DESC').first
          else
            segment = Segment.find_by_sql('SELECT SUM(duration) AS duration FROM segments GROUP BY strftime("%Y %m", start_time) ORDER BY duration DESC').first
          end

          record.best_month_duration = segment.duration || 0
        end

        # Sets the best week records.
        def update_best_week(record)
          update_best_week_distance(record)
          update_best_week_duration(record)
        end

        # Sets the best week distance record.
        def update_best_week_distance(record)
          if mysql?
            segment = Segment.find_by_sql('SELECT SUM(distance) AS distance FROM segments GROUP BY date_format(start_time, "%Y %W") ORDER BY distance DESC').first
          else
            segment = Segment.find_by_sql('SELECT SUM(distance) AS distance FROM segments GROUP BY strftime("%Y %W", start_time) ORDER BY distance DESC').first
          end

          record.best_week_distance = segment.distance || 0
        end

        # Sets the best week duration record.
        def update_best_week_duration(record)
          if mysql?
            segment = Segment.find_by_sql('SELECT SUM(duration) AS duration FROM segments GROUP BY date_format(start_time, "%Y %W") ORDER BY duration DESC').first
          else
            segment = Segment.find_by_sql('SELECT SUM(duration) AS duration FROM segments GROUP BY strftime("%Y %W", start_time) ORDER BY duration DESC').first
          end

          record.best_week_duration = segment.duration || 0
        end

        # Determines if the database is MySQL.
        def mysql?
          ActiveRecord::Base.connection.instance_of? ActiveRecord::ConnectionAdapters::MysqlAdapter
        end
      end
    end
  end
end
