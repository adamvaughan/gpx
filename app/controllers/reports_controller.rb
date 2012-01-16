class ReportsController < ApplicationController
  def totals
    @report = Report.current

    if stale?(:last_modified => @report.updated_at, :etag => [Report, @report.updated_at, request.format])
      respond_to do |format|
        format.json
        format.html { render_404 }
      end
    end
  end

  def monthly_distance
    last_modified = Segment.maximum(:updated_at)

    if stale?(:last_modified => last_modified, :etag => [Report, 'monthly_distance', last_modified, request.format])
      respond_to do |format|
        format.json do
          @months = (0..12).inject([]) { |months, index| months.push((Date.today - index.month).strftime('%b %y')) }
          @distances = (0..12).inject([]) { |distances, index| distances.push(Segment.total_distance_for_month(Date.today - index.month)) }
        end

        format.html { render_404 }
      end
    end
  end

  def monthly_duration
    last_modified = Segment.maximum(:updated_at)

    if stale?(:last_modified => last_modified, :etag => [Report, 'monthly_duration', last_modified, request.format])
      respond_to do |format|
        format.json do
          @months = (0..12).inject([]) { |months, index| months.push((Date.today - index.month).strftime('%b %y')) }
          @durations = (0..12).inject([]) { |durations, index| durations.push(Segment.total_duration_for_month(Date.today - index.month)) }
        end

        format.html { render_404 }
      end
    end
  end
end
