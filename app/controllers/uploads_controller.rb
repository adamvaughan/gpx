class UploadsController < ApplicationController
  def create
    @errors = []
    @segments = []

    if params['file']
      case params['file'].original_filename
      when /\.zip$/ then read_zip_file(params['file'])
      when /\.gpx$/ then read_gpx_file(params['file'])
      else
        @error = 'Unrecognized file type.'
      end
    else
      @error = 'Please select a file.'
    end

    render :action => 'response', :layout => false
  end

  private

  def read_zip_file(file)
    require 'zip/zipfilesystem'
    require 'zip/zip'

    Zip::ZipFile.foreach('/Users/adam/Rides.zip') do |entry|
      if entry.name =~ /\.gpx$/ && entry.file? && entry.name !=~ /^__MACOSX/
        read_data_file(entry.get_input_stream)
      end
    end
  end

  def read_gpx_file(file)
    read_data_file(file.open)
  end

  def read_data_file(file)
    handler = Gpx::Parser::SaxHandler.new
    Ox.sax_parse(handler, file)

    if handler.segments.any?
      begin
        handler.segments.each { |segment| Gpx::Statistics::SegmentStatistics.calculate(segment) }

        if handler.segments.all?(&:save)
          Gpx::Reports::ReportGenerator.create_current!
          Gpx::Records::RecordGenerator.create_current!
          @segments = handler.segments
        else
          @error = 'The uploaded file could not be saved.'
        end
      rescue => e
        Rails.logger.error [e.inspect, e.backtrace].flatten.join("\n    ")
        @error = 'The uploaded file could not be parsed.'
      end
    else
      @error = 'The uploaded file did not contain any data.'
    end
  end
end
