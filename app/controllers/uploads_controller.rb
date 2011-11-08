class UploadsController < ApplicationController
  def create
    if params['file']
      file = params['file'].open
      handler = Gpx::Parser::SaxHandler.new
      Ox.sax_parse(handler, file)

      if handler.segments.any?
        handler.segments.each { |segment| Gpx::Statistics::SegmentStatistics.calculate(segment) }

        if handler.segments.all?(&:save)
          flash[:notice] = 'Upload successful.'
        else
          flash[:error] = 'The uploaded file could not be saved.'
        end
      else
        flash[:error] = 'The uploaded file did not contain any data.'
      end
    else
      flash[:error] = 'Please select a file.'
    end

    redirect_to segments_url
  end
end
