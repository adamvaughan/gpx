module Gpx
  module Parser
    class SaxHandler < Ox::Sax
      attr_accessor :rides

      def initialize
        @current_state = []
        @rides = []
      end

      def start_element(name)
        @current_state.push name

        case @current_state
        when [:gpx, :trk, :trkseg]
          @ride = Ride.new
        when [:gpx, :trk, :trkseg, :trkpt]
          @point = Point.new
        end
      end

      def end_element(name)
        case @current_state
        when [:gpx, :trk, :trkseg]
          @rides << @ride
        when [:gpx, :trk, :trkseg, :trkpt]
          @ride.points << @point
        end

        @current_state.pop
      end

      def attr(name, value)
        if @current_state == [:gpx, :trk, :trkseg, :trkpt]
          case name
          when :lat
            @point.latitude = value.to_f
          when :lon
            @point.longitude = value.to_f
          end
        end
      end

      def text(value)
        case @current_state
        when [:gpx, :trk, :trkseg, :trkpt, :ele]
          @point.elevation = value.to_f
        when [:gpx, :trk, :trkseg, :trkpt, :time]
          @point.time = Time.parse(value)
        when [:gpx, :trk, :trkseg, :trkpt, :extensions, :'gpxtpx:TrackPointExtension', :'gpxtpx:hr']
          @point.heart_rate = value.to_i
        when [:gpx, :trk, :trkseg, :trkpt, :extensions, :'gpxtpx:TrackPointExtension', :'gpxtpx:cad']
          @point.cadence = value.to_i
        end
      end
    end
  end
end
