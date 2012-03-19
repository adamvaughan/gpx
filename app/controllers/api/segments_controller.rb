class Api::SegmentsController < Api::BaseController
  def index
    last_modified = Segment.maximum(:updated_at)

    if stale?(:last_modified => last_modified, :etag => [last_modified, params[:page]])
      @segments = Segment.page(params[:page])
    end
  end

  def show
    @segment = Segment.find(params[:id])
    fresh_when @segment
  end
end
