class ReportsController < ApplicationController
  def show
    @report = Report.current

    if stale?(:last_modified => @report.updated_at, :etag => [Report, @report.updated_at, request.format])
      respond_to do |format|
        format.json
        format.html { render_404 }
      end
    end
  end
end
