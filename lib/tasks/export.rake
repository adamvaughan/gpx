namespace :data do
  desc "Export ride data to GPX files."
  task :export => :environment do
    require 'zip/zip'

    print "Exporting rides to GPX files...\n"

    rides = Ride.all
    tmp = "#{Rails.root}/tmp"
    files = []

    rides.each do |ride|
      file = "#{tmp}/Ride - #{ride.start_time.to_s(:long).gsub(/[:,]/, '')}.gpx"
      File.delete(file) if File.exists?(file)
      Gpx::Exporter.export ride, file
      files << file
    end

    archive = "#{Rails.root}/export.zip"
    File.delete(archive) if File.exists?(archive)

    Zip::ZipOutputStream.open archive do |zipFile|
      files.each do |file|
        zipFile.put_next_entry File.basename(file)
        zipFile.print IO.read(file)
      end
    end

    puts "Export to #{archive} is complete."
  end
end
