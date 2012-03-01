class SummaryController < ApplicationController
  def index
    last_modified = Segment.maximum(:updated_at)

    if stale?(:last_modified => last_modified, :etag => last_modified)
      @last_segment = SegmentDecorator.decorate(Segment.first)
      @recent_segments = SegmentDecorator.decorate(Segment.offset(1).limit(10))
    end
  end
end
