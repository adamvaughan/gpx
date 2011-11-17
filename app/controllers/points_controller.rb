class PointsController < ApplicationController
  def index
    @segment = Segment.find(params[:segment_id])
    last_modified = @segment.points.maximum(:updated_at)

    if stale?(:last_modified => last_modified, :etag => [params[:segment_id], Point, last_modified, request.format])
      respond_to do |format|
        format.json { @points = @segment.points }
        format.html { render_404 }
      end
    end
  end
end
