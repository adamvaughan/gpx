class ReportsController < ApplicationController
  def totals
    @report = Report.current
    fresh_when @report
  end

  # def monthly_distance
  #   last_modified = Segment.maximum(:updated_at)

  #   if stale?(:last_modified => last_modified, :etag => ['monthly_distance', last_modified])
  #     @months = (0..12).inject([]) { |months, index| months.push((Date.today - index.month).strftime('%b %y')) }
  #     @distances = (0..12).inject([]) { |distances, index| distances.push(Segment.total_distance_for_month(Date.today - index.month)) }
  #   end
  # end

  # def monthly_duration
  #   last_modified = Segment.maximum(:updated_at)

  #   if stale?(:last_modified => last_modified, :etag => ['monthly_duration', last_modified])
  #     @months = (0..12).inject([]) { |months, index| months.push((Date.today - index.month).strftime('%b %y')) }
  #     @durations = (0..12).inject([]) { |durations, index| durations.push(Segment.total_duration_for_month(Date.today - index.month)) }
  #   end
  # end

  # def annual_distance
  #   last_modified = Segment.maximum(:updated_at)

  #   if stale?(:last_modified => last_modified, :etag => ['annual_distance', last_modified])
  #     @years = (0..10).inject([]) { |years, index| years.push((Date.today - index.year).strftime('%Y')) }
  #     @distances = (0..10).inject([]) { |distances, index| distances.push(Segment.total_distance_for_year(Date.today - index.year)) }
  #   end
  # end

  # def annual_duration
  #   last_modified = Segment.maximum(:updated_at)

  #   if stale?(:last_modified => last_modified, :etag => ['annual_duration', last_modified])
  #     @years = (0..10).inject([]) { |years, index| years.push((Date.today - index.year).strftime('%Y')) }
  #     @durations = (0..10).inject([]) { |durations, index| durations.push(Segment.total_duration_for_year(Date.today - index.year)) }
  #   end
  # end
end
