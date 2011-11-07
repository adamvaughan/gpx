class SegmentsController < ApplicationController
  def index
    # TODO add caching support
    @segments = SegmentDecorator.decorate(Segment.all.sort)
  end

  def show
    # TODO add caching support
    @segment = SegmentDecorator.find(params[:id])
  end

  def edit
    @segment = Segment.find(params[:id])
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
