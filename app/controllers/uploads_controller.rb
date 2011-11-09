class UploadsController < ApplicationController
  def create
    @errors = []
    @segments = []

    if params['file']
      file = params['file'].open
      handler = Gpx::Parser::SaxHandler.new
      Ox.sax_parse(handler, file)

      if handler.segments.any?
        handler.segments.each { |segment| Gpx::Statistics::SegmentStatistics.calculate(segment) }

        if handler.segments.all?(&:save)
          @segments = handler.segments
        else
          @errors << 'The uploaded file could not be saved.'
        end
      else
        @errors << 'The uploaded file did not contain any data.'
      end
    else
      @errors << 'Please select a file.'
    end

    render :file => 'uploads/response.json.rabl'
  end
end
