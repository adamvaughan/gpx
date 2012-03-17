class Api::SegmentsController < Api::BaseController
  def index
    last_modified = Segment.maximum(:updated_at)

    if stale?(:last_modified => last_modified, :etag => last_modified)
      @segments = Segment.all
    end
  end

  def show
    @segment = Segment.find(params[:id])
    fresh_when @segment
  end
end
