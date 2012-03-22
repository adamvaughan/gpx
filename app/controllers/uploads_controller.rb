class UploadsController < ApplicationController
  def create
    @rides = []

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

    count = 0

    Zip::ZipFile.foreach(file.tempfile.path) do |entry|
      if entry.name =~ /\.gpx$/ && entry.file? && entry.name !=~ /^__MACOSX/
        read_data_file(entry.get_input_stream)
        count += 1
      end
    end

    if count > 0
      Gpx::Reports::ReportGenerator.create_current!
    else
      @error = 'Zip file did not contain any data files.'
    end
  end

  def read_gpx_file(file)
    read_data_file(file.open)
    Gpx::Reports::ReportGenerator.create_current!
  end

  def read_data_file(file)
    handler = Gpx::Parser::SaxHandler.new
    Ox.sax_parse(handler, file)

    if handler.rides.any?
      begin
        handler.rides.each { |ride| Gpx::Statistics::RideStatistics.calculate(ride) }

        if handler.rides.all?(&:save)
          @rides = handler.rides
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
