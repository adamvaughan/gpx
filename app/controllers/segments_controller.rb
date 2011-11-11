class SegmentsController < ApplicationController
  def index
    last_modified = Segment.maximum(:updated_at)

    if stale?(:last_modified => last_modified, :etag => [Segment, last_modified, request.format])
      @segments = Segment.all
    end
  end

  def update
    @segment = Segment.find(params[:id])

    if @segment.update_attributes(params[:segment])
      redirect_to root_url, :notice => 'Update successful.'
    else
      render :action => :edit
    end
  end
end
