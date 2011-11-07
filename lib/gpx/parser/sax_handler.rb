module Gpx
  module Parser
    class SaxHandler < Ox::Sax
      attr_accessor :segments

      def initialize
        @current_state = []
        @segments = []
      end

      def start_element(name)
        @current_state.push name

        case @current_state
        when [:gpx, :trk, :trkseg]
          @segment = Segment.new(:name => @name)
        when [:gpx, :trk, :trkseg, :trkpt]
          @point = Point.new
        end
      end

      def end_element(name)
        case @current_state
        when [:gpx, :trk, :trkseg]
          @segments << @segment
        when [:gpx, :trk, :trkseg, :trkpt]
          @segment.points << @point
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

      def cdata(value)
        if @current_state == [:gpx, :trk, :name]
          @name = value
        end
      end

      def text(value)
        case @current_state
        when [:gpx, :trk, :name]
          @name = value
        when [:gpx, :trk, :trkseg, :trkpt, :ele]
          @point.elevation = value.to_f
        when [:gpx, :trk, :trkseg, :trkpt, :time]
          @point.time = Time.parse(value)
        end
      end
    end
  end
end
