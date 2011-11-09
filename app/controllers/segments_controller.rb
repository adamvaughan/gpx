class SegmentsController < ApplicationController
  def index
    # TODO add caching support
    @segments = Segment.all.sort
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
