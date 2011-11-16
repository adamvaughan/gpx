class HistoryController < ApplicationController
  def index
    last_modified = Segment.maximum(:updated_at)

    if stale?(:last_modified => last_modified, :etag => [Segment, 'history', last_modified, request.format])
      respond_to do |format|
        format.json do
          @segments = Segment.this_year
          @distance_this_year = @segments.inject(0) { |total, segment| total + segment.distance }
          @distance_this_month = segments_this_month(@segments).inject(0) { |total, segment| total + segment.distance }
          @distance_this_week = segments_this_week(@segments).inject(0) { |total, segment| total + segment.distance }
        end
        format.html { render "#{Rails.root}/public/404.html", :layout => false, :status => :not_found }
      end
    end
  end

  private

  def segments_this_month(segments)
    current_month = Date.today.month
    segments.select { |segment| segment.start_time.month == current_month }
  end

  def segments_this_week(segments)
    current_week = Date.today.cweek
    segments.select { |segment| segment.start_time.to_date.cweek == current_week }
  end
end
