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

        # Sets the best segment record.
        def update_best_segment(record)
          segment = Segment.unscoped.order('distance DESC').first

          if segment
            record.best_segment_id = segment.id unless record.best_segment_id == segment.id
          else
            record.best_segment = 0
          end
        end

        # Sets the best year record.
        def update_best_year(record)
          segment = Segment.find_by_sql('SELECT SUM(distance) AS distance FROM segments GROUP BY strftime("%Y", start_time) ORDER BY distance DESC').first
          record.best_year = segment.distance ? segment.distance : 0
        end

        # Sets the best year record.
        def update_best_month(record)
          segment = Segment.find_by_sql('SELECT SUM(distance) AS distance FROM segments GROUP BY strftime("%Y %m", start_time) ORDER BY distance DESC').first
          record.best_month = segment.distance ? segment.distance : 0
        end

        # Sets the best year record.
        def update_best_week(record)
          segment = Segment.find_by_sql('SELECT SUM(distance) AS distance FROM segments GROUP BY strftime("%Y %W", start_time) ORDER BY distance DESC').first
          record.best_week = segment.distance ? segment.distance : 0
        end
      end
    end
  end
end
