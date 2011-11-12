require 'spec_helper'

# TODO test with points where the time between the points is zero
# TODO test with points where the distance between the points is zero
# TODO test that point attributes get properly set as well

describe Gpx::Statistics::SegmentStatistics do
  let(:segment) { Segment.new }

  before do
  end

  describe "#start_time" do
    it "is nill when no points exist" do
      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.start_time.should be_nil
    end
  end

  describe "#distance" do
    it "is zero when no points exist" do
      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.distance.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.distance.should eq(0)
    end

    it "correctly computes the distance between points" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.distance.should be_within(0.0000001).of(6936.4947082)
    end
  end

  describe "#ascending_distance" do
    it "is zero when no points exist" do
      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.ascending_distance.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :elevation => 1000)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.ascending_distance.should eq(0)
    end

    it "is zero when all points are descending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :elevation => 1000)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :elevation => 500)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.ascending_distance.should eq(0)
    end

    it "correctly computes the distance between points when ascending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :elevation => 500)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :elevation => 1000)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.ascending_distance.should be_within(0.0000001).of(6936.4947082)
    end
  end

  describe "#descending_distance" do
    it "is zero when no points exist" do
      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.descending_distance.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :elevation => 500)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.descending_distance.should eq(0)
    end

    it "is zero when all points are ascending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :elevation => 500)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :elevation => 1000)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.descending_distance.should eq(0)
    end

    it "correctly computes the distance between points when descending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :elevation => 1000)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :elevation => 500)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.descending_distance.should be_within(0.0000001).of(6936.4947082)
    end
  end

  describe "#flat_distance" do
    it "is zero when no points exist" do
      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.flat_distance.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :elevation => 500)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.flat_distance.should eq(0)
    end

    it "is zero when all points are ascending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :elevation => 500)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :elevation => 1000)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.flat_distance.should eq(0)
    end

    it "is zero when all points are descending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :elevation => 1000)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :elevation => 500)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.flat_distance.should eq(0)
    end

    it "correctly computes the distance between points with no elevation change" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :elevation => 1000)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :elevation => 1000)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.flat_distance.should be_within(0.0000001).of(6936.4947082)
    end
  end

  describe "#elevation_gain" do
    it "is zero when no points exist" do
      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.elevation_gain.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:elevation => 2044.1)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.elevation_gain.should eq(0)
    end

    it "correctly computes the elevation gain between points" do
      segment.points << Point.new(:elevation => 2044.1)
      segment.points << Point.new(:elevation => 2047.9)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.elevation_gain.should be_within(0.0000001).of(3.8)
    end
  end

  describe "#elevation_loss" do
    it "is zero when no points exist" do
      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.elevation_loss.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:elevation => 2047.9)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.elevation_loss.should eq(0)
    end

    it "correctly computes the elevation loss between points" do
      segment.points << Point.new(:elevation => 2047.9)
      segment.points << Point.new(:elevation => 2044.1)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.elevation_loss.should be_within(0.0000001).of(3.8)
    end
  end

  describe "#elevation_change" do
    it "is zero when no points exist" do
      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.elevation_change.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:elevation => 2047.9)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.elevation_change.should eq(0)
    end

    it "correctly computes the elevation change between points" do
      segment.points << Point.new(:elevation => 2047.9)
      segment.points << Point.new(:elevation => 2044.1)
      segment.points << Point.new(:elevation => 2045.6)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.elevation_change.should be_within(0.0000001).of(3.8)
    end
  end

  describe "#maximum_elevation" do
    it "is zero when no points exist" do
      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.maximum_elevation.should eq(0)
    end

    it "is the value of the only point when one point exists" do
      segment.points << Point.new(:elevation => 2047.9)
      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.maximum_elevation.should eq(2047.9)
    end

    it "correctly computes the maximum elevation between points" do
      segment.points << Point.new(:elevation => 2044.1)
      segment.points << Point.new(:elevation => 2047.9)
      segment.points << Point.new(:elevation => 2045.6)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.maximum_elevation.should eq(2047.9)
    end
  end

  describe "#minimum_elevation" do
    it "is zero when no points exist" do
      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.minimum_elevation.should eq(0)
    end

    it "is the value of the only point when one point exists" do
      segment.points << Point.new(:elevation => 2047.9)
      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.minimum_elevation.should eq(2047.9)
    end

    it "correctly computes the maximum elevation between points" do
      segment.points << Point.new(:elevation => 2047.9)
      segment.points << Point.new(:elevation => 2045.6)
      segment.points << Point.new(:elevation => 2044.1)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.minimum_elevation.should eq(2044.1)
    end
  end

  describe "#duration" do
    it "is zero when no points exist" do
      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.duration.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:time => Time.at(1000))

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.duration.should eq(0)
    end

    it "correctly computes the duration between points" do
      segment.points << Point.new(:time => Time.at(1000))
      segment.points << Point.new(:time => Time.at(2000))

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.duration.should be_within(0.0000001).of(1000.0)
    end
  end

  describe "#active_duration" do
    it "is zero when no points exist" do
      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.active_duration.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:latitude => 39.369981, :longitude => -105.338548, :time => Time.at(1000))

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.active_duration.should eq(0)
    end

    it "is zero when the speed between points does not get above 0.5 m/s" do
      segment.points << Point.new(:latitude => 39.369981, :longitude => -105.338548, :time => Time.at(1000))
      segment.points << Point.new(:latitude => 39.370139, :longitude => -105.338413, :time => Time.at(2000))
      segment.points << Point.new(:latitude => 39.370302, :longitude => -105.338519, :time => Time.at(3000))

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.active_duration.should eq(0)
    end

    it "correctly computes the duration between points when active" do
      segment.points << Point.new(:latitude => 39.369981, :longitude => -105.338548, :time => Time.at(1000))
      segment.points << Point.new(:latitude => 39.370139, :longitude => -105.338413, :time => Time.at(1012))
      segment.points << Point.new(:latitude => 39.370302, :longitude => -105.338519, :time => Time.at(1034))
      segment.points << Point.new(:latitude => 39.370149, :longitude => -105.339224, :time => Time.at(10000))

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.active_duration.should eq(34.0)
    end
  end

  describe "#ascending_duration" do
    it "is zero when no points exist" do
      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.ascending_duration.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:time => Time.at(1000), :elevation => 1000)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.ascending_duration.should eq(0)
    end

    it "is zero when all points are descending" do
      segment.points << Point.new(:time => Time.at(1000), :elevation => 1000)
      segment.points << Point.new(:time => Time.at(2000), :elevation => 500)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.ascending_duration.should eq(0)
    end

    it "correctly computes the elapsed time between points when ascending" do
      segment.points << Point.new(:time => Time.at(1000), :elevation => 500)
      segment.points << Point.new(:time => Time.at(2000), :elevation => 1000)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.ascending_duration.should eq(1000.0)
    end
  end

  describe "#descending_duration" do
    it "is zero when no points exist" do
      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.descending_duration.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:time => Time.at(1000), :elevation => 500)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.descending_duration.should eq(0)
    end

    it "is zero when all points are ascending" do
      segment.points << Point.new(:time => Time.at(1000), :elevation => 500)
      segment.points << Point.new(:time => Time.at(2000), :elevation => 1000)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.descending_duration.should eq(0)
    end

    it "correctly computes the elapsed time between points when descending" do
      segment.points << Point.new(:time => Time.at(1000), :elevation => 1000)
      segment.points << Point.new(:time => Time.at(2000), :elevation => 500)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.descending_duration.should eq(1000.0)
    end
  end

  describe "#flat_duration" do
    it "is zero when no points exist" do
      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.flat_duration.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:time => Time.at(1000), :elevation => 500)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.flat_duration.should eq(0)
    end

    it "is zero when all points are ascending" do
      segment.points << Point.new(:time => Time.at(1000), :elevation => 500)
      segment.points << Point.new(:time => Time.at(2000), :elevation => 1000)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.flat_duration.should eq(0)
    end

    it "is zero when all points are descending" do
      segment.points << Point.new(:time => Time.at(1000), :elevation => 1000)
      segment.points << Point.new(:time => Time.at(2000), :elevation => 500)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.flat_duration.should eq(0)
    end

    it "correctly computes the elapsed time between points with no elevation change" do
      segment.points << Point.new(:time => Time.at(1000), :elevation => 1000)
      segment.points << Point.new(:time => Time.at(2000), :elevation => 1000)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.flat_duration.should eq(1000.0)
    end
  end

  describe "#average_pace" do
    it "is zero when no points exist" do
      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_pace.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000))

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_pace.should eq(0)
    end

    it "correctly computes the average pace between points" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000))
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(20000))
      segment.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(300000))

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_pace.should be_within(0.0000001).of(11.3234376)
    end
  end

  describe "#average_active_pace" do
    it "is zero when no points exist" do
      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_active_pace.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:latitude => 39.369981, :longitude => -105.338548, :time => Time.at(1000))

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_active_pace.should eq(0)
    end

    it "is zero when the speed between points does not get above 0.5 m/s" do
      segment.points << Point.new(:latitude => 39.369981, :longitude => -105.338548, :time => Time.at(1000))
      segment.points << Point.new(:latitude => 39.370139, :longitude => -105.338413, :time => Time.at(2000))
      segment.points << Point.new(:latitude => 39.370302, :longitude => -105.338519, :time => Time.at(3000))

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_active_pace.should eq(0)
    end

    it "correctly computes the average pace between points when active" do
      segment.points << Point.new(:latitude => 39.369981, :longitude => -105.338548, :time => Time.at(1000))
      segment.points << Point.new(:latitude => 39.370139, :longitude => -105.338413, :time => Time.at(1012))
      segment.points << Point.new(:latitude => 39.370302, :longitude => -105.338519, :time => Time.at(1034))
      segment.points << Point.new(:latitude => 39.370149, :longitude => -105.339224, :time => Time.at(10000))

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_active_pace.should be_within(0.0000001).of(0.8262746)
    end
  end

  describe "#average_ascending_pace" do
    it "is zero when no points exist" do
      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_ascending_pace.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1000)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_ascending_pace.should eq(0)
    end

    it "is zero when all points are descending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1000)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 500)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_ascending_pace.should eq(0)
    end

    it "correctly computes the average pace between points when ascending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 500)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(20000), :elevation => 1000)
      segment.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(300000), :elevation => 1500)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_ascending_pace.should be_within(0.0000001).of(11.3234376)
    end
  end

  describe "#average_descending_pace" do
    it "is zero when no points exist" do
      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_descending_pace.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 500)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_descending_pace.should eq(0)
    end

    it "is zero when all points are ascending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 500)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_descending_pace.should eq(0)
    end

    it "correctly computes the average pace between points when descending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1500)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(20000), :elevation => 1000)
      segment.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(300000), :elevation => 500)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_descending_pace.should be_within(0.0000001).of(11.3234376)
    end
  end

  describe "#average_flat_pace" do
    it "is zero when no points exist" do
      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_flat_pace.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 500)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_flat_pace.should eq(0)
    end

    it "is zero when all points are ascending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 500)

      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)
      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_flat_pace.should eq(0)
    end

    it "is zero when all points are descending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1000)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 500)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_flat_pace.should eq(0)
    end

    it "correctly computes the average pace between points with no elevation change" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1000)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(20000), :elevation => 1000)
      segment.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(300000), :elevation => 1000)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_flat_pace.should be_within(0.0000001).of(11.3234376)
    end
  end

  describe "#average_speed" do
    it "is zero when no points exist" do
      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_speed.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000))

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_speed.should eq(0)
    end

    it "correctly computes the average speed between points" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000))
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000))
      segment.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(3000))

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_speed.should be_within(0.0000001).of(10.5006881)
    end
  end

  describe "#average_active_speed" do
    it "is zero when no points exist" do
      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_active_speed.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:latitude => 39.369981, :longitude => -105.338548, :time => Time.at(1000))

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_active_speed.should eq(0)
    end

    it "is zero when the speed between points does not get above 0.5 m/s" do
      segment.points << Point.new(:latitude => 39.369981, :longitude => -105.338548, :time => Time.at(1000))
      segment.points << Point.new(:latitude => 39.370139, :longitude => -105.338413, :time => Time.at(2000))
      segment.points << Point.new(:latitude => 39.370302, :longitude => -105.338519, :time => Time.at(3000))

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_active_speed.should eq(0)
    end

    it "correctly computes the average speed between points when active" do
      segment.points << Point.new(:latitude => 39.369981, :longitude => -105.338548, :time => Time.at(1000))
      segment.points << Point.new(:latitude => 39.370139, :longitude => -105.338413, :time => Time.at(1012))
      segment.points << Point.new(:latitude => 39.370302, :longitude => -105.338519, :time => Time.at(1034))
      segment.points << Point.new(:latitude => 39.370149, :longitude => -105.339224, :time => Time.at(10000))

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_active_speed.should be_within(0.0000001).of(1.3398617)
    end
  end

  describe "#average_ascending_speed" do
    it "is zero when no points exist" do
      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_ascending_speed.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1000)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_ascending_speed.should eq(0)
    end

    it "is zero when all points are descending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1500)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)
      segment.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(3000), :elevation => 500)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_ascending_speed.should eq(0)
    end

    it "correctly computes the average speed between points when ascending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 500)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)
      segment.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(3000), :elevation => 1500)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_ascending_speed.should be_within(0.0000001).of(10.5006881)
    end
  end

  describe "#average_descending_speed" do
    it "is zero when no points exist" do
      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_descending_speed.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 500)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_descending_speed.should eq(0)
    end

    it "is zero when all points are ascending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 500)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)
      segment.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(3000), :elevation => 1500)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_descending_speed.should eq(0)
    end

    it "correctly computes the average speed between points when descending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1500)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)
      segment.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(3000), :elevation => 500)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_descending_speed.should be_within(0.0000001).of(10.5006881)
    end
  end

  describe "#average_flat_speed" do
    it "is zero when no points exist" do
      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_flat_speed.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 500)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_flat_speed.should eq(0)
    end

    it "is zero when all points are ascending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 500)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)
      segment.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(3000), :elevation => 1500)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_flat_speed.should eq(0)
    end

    it "is zero when all points are descending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1500)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)
      segment.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(3000), :elevation => 500)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_flat_speed.should eq(0)
    end

    it "correctly computes the average speed between points with no elevation change" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1000)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)
      segment.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(3000), :elevation => 1000)

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.average_flat_speed.should be_within(0.0000001).of(10.5006881)
    end
  end

  describe "#maximum_speed" do
    it "is zero when no points exist" do
      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.maximum_speed.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000))

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.maximum_speed.should eq(0)
    end

    it "correctly computes the maximum speed between points" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000))
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000))
      segment.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(3000))

      Gpx::Statistics::SegmentStatistics.calculate(segment)
      segment.maximum_speed.should be_within(0.0000001).of(14.0648815)
    end
  end
end
