module Gpx
  class Exporter
    def self.export(ride, path)
      file = File.open(path, 'w')

      file.write "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"
      file.write "<gpx xmlns=\"http://www.topografix.com/GPX/1/1\" xmlns:gpxx=\"http://www.garmin.com/xmlschemas/GpxExtensions/v3\" xmlns:wptx1=\"http://www.garmin.com/xmlschemas/WaypointExtension/v1\" xmlns:gpxtpx=\"http://www.garmin.com/xmlschemas/TrackPointExtension/v1\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" version=\"1.1\" xsi:schemaLocation=\"http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd http://www.garmin.com/xmlschemas/GpxExtensions/v3 http://www8.garmin.com/xmlschemas/GpxExtensionsv3.xsd http://www.garmin.com/xmlschemas/WaypointExtension/v1 http://www8.garmin.com/xmlschemas/WaypointExtensionv1.xsd http://www.garmin.com/xmlschemas/TrackPointExtension/v1 http://www.garmin.com/xmlschemas/TrackPointExtensionv1.xsd\">"
      file.write "<trk>"
      file.write "<name>#{ride.start_time.to_s(:long)}</name>"
      file.write "<trkseg>"

      ride.points.each do |point|
        file.write "<trkpt lat=\"#{point.latitude}\" lon=\"#{point.longitude}\">"
        file.write "<ele>#{point.elevation}</ele>"
        file.write "<time>#{point.time.iso8601}</time>"

        if point.heart_rate
          file.write "<extensions>"
          file.write "<gpxtpx:TrackPointExtension>"
          file.write "<gpxtpx:hr>#{point.heart_rate}</gpxtpx:hr>"
          file.write "</gpxtpx:TrackPointExtension>"
          file.write "</extensions>"
        end

        file.write "</trkpt>"
      end

      file.write "</trkseg>"
      file.write "</trk>"
      file.write "</gpx>"
      file.close
    end
  end
end
