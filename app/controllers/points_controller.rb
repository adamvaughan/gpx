class PointsController < ApplicationController
  def index
    #TODO add caching support
    respond_to do |format|
      format.json do
        @segment = Segment.find(params[:segment_id])
        @points = @segment.points.order('time')
      end
    end
  end
end
