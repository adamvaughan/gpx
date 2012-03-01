class PointsController < ApplicationController
  def index
    @segment = Segment.find(params[:segment_id])

    if stale?(@segment)
      @points = @segment.points
    end
  end
end
