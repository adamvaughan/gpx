class Api::PointsController < Api::BaseController
  def index
    @ride = Ride.find(params[:ride_id])

    if stale?(@ride)
      @points = @ride.points
    end
  end
end
