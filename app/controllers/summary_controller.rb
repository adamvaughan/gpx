class SummaryController < ApplicationController
  def index
    @last_segment = SegmentDecorator.decorate(Segment.first)
    @recent_segments = SegmentDecorator.decorate(Segment.offset(1).limit(10))
  end
end
