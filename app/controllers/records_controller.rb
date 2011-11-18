class RecordsController < ApplicationController
  def show
    @record = Record.current

    if stale?(:last_modified => @record.updated_at, :etag => [Record, @record.updated_at, request.format])
      respond_to do |format|
        format.json
        format.html { render_404 }
      end
    end
  end
end
