require 'spec_helper'

describe Gpx::Statistics::RideStatistics do
  let(:ride) { Ride.new }

  describe ".start_time" do
    context "when no points exist" do
      it "is nil" do
        Gpx::Statistics::RideStatistics.start_time(ride).should be_nil
      end
    end

    context "when points exist" do
      let(:time) { Time.now }

      before do
        ride.points << Point.new(:time => time)
        ride.points << Point.new(:time => time + 1000)
      end

      it "is set to the timestamp of the first point" do
        Gpx::Statistics::RideStatistics.start_time(ride).should eq(time)
      end
    end
  end

  describe ".distance" do
    context "when no points exist" do
      it "is zero" do
        Gpx::Statistics::RideStatistics.distance(ride).should eq(0)
      end
    end

    context "when one point exists" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.distance(ride).should eq(0)
      end
    end

    context "when multiple points exist" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000)
        ride.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000)
      end

      it "correctly computes the distance between points" do
        Gpx::Statistics::RideStatistics.distance(ride).should be_within(0.0000001).of(6913.4565666)
      end
    end
  end

  describe ".ascending_distance" do
    context "when no points exist" do
      it "is zero" do
        Gpx::Statistics::RideStatistics.ascending_distance(ride).should eq(0)
      end
    end

    context "when one point exists" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :elevation => 1000)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.ascending_distance(ride).should eq(0)
      end
    end

    context "when all points are descending" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :elevation => 1000)
        ride.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :elevation => 500)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.ascending_distance(ride).should eq(0)
      end
    end

    context "when points are ascending" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :elevation => 500)
        ride.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :elevation => 1000)
      end

      it "correctly computes the distance between ascending points" do
        Gpx::Statistics::RideStatistics.ascending_distance(ride).should be_within(0.0000001).of(6913.4565666)
      end
    end
  end

  describe ".descending_distance" do
    context "when no points exist" do
      it "is zero" do
        Gpx::Statistics::RideStatistics.descending_distance(ride).should eq(0)
      end
    end

    context "when one point exists" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :elevation => 500)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.descending_distance(ride).should eq(0)
      end
    end

    context "when all points are ascending" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :elevation => 500)
        ride.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :elevation => 1000)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.descending_distance(ride).should eq(0)
      end
    end

    context "when points are descending" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :elevation => 1000)
        ride.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :elevation => 500)
      end

      it "correctly computes the distance between descending points" do
        Gpx::Statistics::RideStatistics.descending_distance(ride).should be_within(0.0000001).of(6913.4565666)
      end
    end
  end

  describe ".flat_distance" do
    context "when no points exist" do
      it "is zero" do
        Gpx::Statistics::RideStatistics.flat_distance(ride).should eq(0)
      end
    end

    context "when one point exists" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :elevation => 500)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.flat_distance(ride).should eq(0)
      end
    end

    context "when all points are ascending" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :elevation => 500)
        ride.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :elevation => 1000)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.flat_distance(ride).should eq(0)
      end
    end

    context "when all points are descending" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :elevation => 1000)
        ride.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :elevation => 500)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.flat_distance(ride).should eq(0)
      end
    end

    context "when points have no elevation change" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1000)
        ride.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)
      end

      it "correctly computes the distance between flat points" do
        Gpx::Statistics::RideStatistics.flat_distance(ride).should be_within(0.0000001).of(6913.4565666)
      end
    end
  end

  describe ".elevation_gain" do
    context "when no points exist" do
      it "is zero" do
        Gpx::Statistics::RideStatistics.elevation_gain(ride).should eq(0)
      end
    end

    context "when one point exists" do
      before do
        ride.points << Point.new(:elevation => 2044.1)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.elevation_gain(ride).should eq(0)
      end
    end

    context "when multiple points exist" do
      before do
        ride.points << Point.new(:elevation => 2044.1)
        ride.points << Point.new(:elevation => 2047.9)
      end

      it "correctly computes the elevation gain between points" do
        Gpx::Statistics::RideStatistics.elevation_gain(ride).should be_within(0.0000001).of(3.8)
      end
    end
  end

  describe ".elevation_loss" do
    context "when no points exist" do
      it "is zero" do
        Gpx::Statistics::RideStatistics.elevation_loss(ride).should eq(0)
      end
    end

    context "when one point exists" do
      before do
        ride.points << Point.new(:elevation => 2047.9)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.elevation_loss(ride).should eq(0)
      end
    end

    context "when multiple points exist" do
      before do
        ride.points << Point.new(:elevation => 2047.9)
        ride.points << Point.new(:elevation => 2044.1)
      end

      it "correctly computes the elevation loss between points" do
        Gpx::Statistics::RideStatistics.elevation_loss(ride).should be_within(0.0000001).of(3.8)
      end
    end
  end

  describe ".elevation_change" do
    context "when no points exist" do
      it "is zero" do
        Gpx::Statistics::RideStatistics.elevation_change(ride).should eq(0)
      end
    end

    context "when one point exists" do
      before do
        ride.points << Point.new(:elevation => 2047.9)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.elevation_change(ride).should eq(0)
      end
    end

    context "when multiple points exist" do
      before do
        ride.points << Point.new(:elevation => 2047.9)
        ride.points << Point.new(:elevation => 2044.1)
        ride.points << Point.new(:elevation => 2045.6)
      end

      it "correctly computes the elevation change between points" do
        Gpx::Statistics::RideStatistics.elevation_change(ride).should be_within(0.0000001).of(3.8)
      end
    end
  end

  describe ".maximum_elevation" do
    context "when no points exist" do
      it "is zero" do
        Gpx::Statistics::RideStatistics.maximum_elevation(ride).should eq(0)
      end
    end

    context "when one point exists" do
      before do
        ride.points << Point.new(:elevation => 2047.9)
      end

      it "is the elevation value of the only point" do
        Gpx::Statistics::RideStatistics.maximum_elevation(ride).should eq(2047.9)
      end
    end

    context "when multiple points exist" do
      before do
        ride.points << Point.new(:elevation => 2044.1)
        ride.points << Point.new(:elevation => 2047.9)
        ride.points << Point.new(:elevation => 2045.6)
      end

      it "correctly computes the maximum elevation between points" do
        Gpx::Statistics::RideStatistics.maximum_elevation(ride).should eq(2047.9)
      end
    end
  end

  describe ".minimum_elevation" do
    context "when no points exist" do
      it "is zero" do
        Gpx::Statistics::RideStatistics.minimum_elevation(ride).should eq(0)
      end
    end

    context "when one point exists" do
      before do
        ride.points << Point.new(:elevation => 2047.9)
      end

      it "is the elevation value of the only point" do
        Gpx::Statistics::RideStatistics.minimum_elevation(ride).should eq(2047.9)
      end
    end

    context "when multiple points exist" do
      before do
        ride.points << Point.new(:elevation => 2047.9)
        ride.points << Point.new(:elevation => 2045.6)
        ride.points << Point.new(:elevation => 2044.1)
      end

      it "correctly computes the minimum elevation between points" do
        Gpx::Statistics::RideStatistics.minimum_elevation(ride).should eq(2044.1)
      end
    end
  end

  describe ".duration" do
    context "when no points exist" do
      it "is zero" do
        Gpx::Statistics::RideStatistics.duration(ride).should eq(0)
      end
    end

    context "when one point exists" do
      before do
        ride.points << Point.new(:time => Time.at(1000))
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.duration(ride).should eq(0)
      end

      it "sets the duration on the point to zero" do
        Gpx::Statistics::RideStatistics.duration(ride)
        ride.points.first.duration.should eq(0)
      end
    end

    context "when multiple points exist" do
      before do
        ride.points << Point.new(:time => Time.at(1000), :elevation => 1000)
        ride.points << Point.new(:time => Time.at(2000), :elevation => 1000)
      end

      it "correctly computes the duration between points" do
        Gpx::Statistics::RideStatistics.duration(ride).should be_within(0.0000001).of(1000.0)
      end

      it "sets the duration on the points" do
        Gpx::Statistics::RideStatistics.duration(ride).should be_within(0.0000001).of(1000.0)
        ride.points.first.duration.should eq(0)
        ride.points.second.duration.should be_within(0.0000001).of(1000.0)
      end
    end
  end

  describe ".active_duration" do
    context "when no points exist" do
      it "is zero" do
        Gpx::Statistics::RideStatistics.active_duration(ride).should eq(0)
      end
    end

    context "when one point exists" do
      before do
        ride.points << Point.new(:latitude => 39.369981, :longitude => -105.338548, :time => Time.at(1000))
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.active_duration(ride).should eq(0)
      end

      it "sets the active duration on the point to zero" do
        Gpx::Statistics::RideStatistics.active_duration(ride)
        ride.points.first.active_duration.should eq(0)
      end
    end

    context "when inactive" do
      before do
        ride.points << Point.new(:latitude => 39.369981, :longitude => -105.338548, :time => Time.at(1000))
        ride.points << Point.new(:latitude => 39.370139, :longitude => -105.338413, :time => Time.at(2000))
        ride.points << Point.new(:latitude => 39.370302, :longitude => -105.338519, :time => Time.at(3000))
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.active_duration(ride).should eq(0)
      end

      it "sets the active duration on the points" do
        Gpx::Statistics::RideStatistics.active_duration(ride)
        ride.points.first.active_duration.should eq(0)
        ride.points.second.active_duration.should eq(0)
        ride.points.last.active_duration.should eq(0)
      end
    end

    context "when active between points" do
      before do
        ride.points << Point.new(:latitude => 39.369981, :longitude => -105.338548, :time => Time.at(1000))
        ride.points << Point.new(:latitude => 39.370139, :longitude => -105.338413, :time => Time.at(1012))
        ride.points << Point.new(:latitude => 39.370302, :longitude => -105.338519, :time => Time.at(1034))
        ride.points << Point.new(:latitude => 39.370149, :longitude => -105.339224, :time => Time.at(10000))
      end

      it "correctly computes the duration between points when active" do
        Gpx::Statistics::RideStatistics.active_duration(ride).should eq(34.0)
      end

      it "sets the active duration on the points" do
        Gpx::Statistics::RideStatistics.active_duration(ride)
        ride.points.first.active_duration.should eq(0)
        ride.points.second.active_duration.should eq(12.0)
        ride.points.third.active_duration.should eq(34.0)
        ride.points.last.active_duration.should eq(0)
      end
    end
  end

  describe ".ascending_duration" do
    context "when no points exist" do
      it "is zero" do
        Gpx::Statistics::RideStatistics.ascending_duration(ride).should eq(0)
      end
    end

    context "when one point exists" do
      before do
        ride.points << Point.new(:time => Time.at(1000), :elevation => 1000)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.ascending_duration(ride).should eq(0)
      end
    end

    context "when all points are descending" do
      before do
        ride.points << Point.new(:time => Time.at(1000), :elevation => 1000, :latitude => 39.366613000, :longitude => -105.352029000)
        ride.points << Point.new(:time => Time.at(2000), :elevation => 500, :latitude => 39.384598000, :longitude => -105.274850000)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.ascending_duration(ride).should eq(0)
      end
    end

    context "when inactive" do
      before do
        ride.points << Point.new(:time => Time.at(1000), :elevation => 500, :latitude => 39.366613000, :longitude => -105.352029000)
        ride.points << Point.new(:time => Time.at(2000), :elevation => 1000, :latitude => 39.366613000, :longitude => -105.352029000)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.ascending_duration(ride).should eq(0)
      end
    end

    context "when points are ascending" do
      before do
        ride.points << Point.new(:time => Time.at(1000), :elevation => 500, :latitude => 39.366613000, :longitude => -105.352029000)
        ride.points << Point.new(:time => Time.at(2000), :elevation => 1000, :latitude => 39.384598000, :longitude => -105.274850000)
      end

      it "correctly computes the elapsed time between points" do
        Gpx::Statistics::RideStatistics.ascending_duration(ride).should eq(1000.0)
      end
    end
  end

  describe ".descending_duration" do
    context "when no points exist" do
      it "is zero" do
        Gpx::Statistics::RideStatistics.descending_duration(ride).should eq(0)
      end
    end

    context "when one point exists" do
      before do
        ride.points << Point.new(:time => Time.at(1000), :elevation => 500)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.descending_duration(ride).should eq(0)
      end
    end

    context "when all points are ascending" do
      before do
        ride.points << Point.new(:time => Time.at(1000), :elevation => 500, :latitude => 39.366613000, :longitude => -105.352029000)
        ride.points << Point.new(:time => Time.at(2000), :elevation => 1000, :latitude => 39.384598000, :longitude => -105.274850000)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.descending_duration(ride).should eq(0)
      end
    end

    context "when inactive" do
      before do
        ride.points << Point.new(:time => Time.at(1000), :elevation => 500, :latitude => 39.366613000, :longitude => -105.352029000)
        ride.points << Point.new(:time => Time.at(2000), :elevation => 1000, :latitude => 39.366613000, :longitude => -105.352029000)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.descending_duration(ride).should eq(0)
      end
    end

    context "when points are descending" do
      before do
        ride.points << Point.new(:time => Time.at(1000), :elevation => 1000, :latitude => 39.366613000, :longitude => -105.352029000)
        ride.points << Point.new(:time => Time.at(2000), :elevation => 500, :latitude => 39.384598000, :longitude => -105.274850000)
      end

      it "correctly computes the elapsed time between points" do
        Gpx::Statistics::RideStatistics.descending_duration(ride).should eq(1000.0)
      end
    end
  end

  describe ".flat_duration" do
    context "when no points exist" do
      it "is zero" do
        Gpx::Statistics::RideStatistics.flat_duration(ride).should eq(0)
      end
    end

    context "when one point exists" do
      before do
        ride.points << Point.new(:time => Time.at(1000), :elevation => 500)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.flat_duration(ride).should eq(0)
      end
    end

    context "when all points are ascending" do
      before do
        ride.points << Point.new(:time => Time.at(1000), :elevation => 500, :latitude => 39.366613000, :longitude => -105.352029000)
        ride.points << Point.new(:time => Time.at(2000), :elevation => 1000, :latitude => 39.384598000, :longitude => -105.274850000)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.flat_duration(ride).should eq(0)
      end
    end

    context "when all points are descending" do
      before do
        ride.points << Point.new(:time => Time.at(1000), :elevation => 1000, :latitude => 39.366613000, :longitude => -105.352029000)
        ride.points << Point.new(:time => Time.at(2000), :elevation => 500, :latitude => 39.384598000, :longitude => -105.274850000)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.flat_duration(ride).should eq(0)
      end
    end

    context "when inactive" do
      before do
        ride.points << Point.new(:time => Time.at(1000), :elevation => 1000, :latitude => 39.366613000, :longitude => -105.352029000)
        ride.points << Point.new(:time => Time.at(2000), :elevation => 500, :latitude => 39.366613000, :longitude => -105.352029000)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.flat_duration(ride).should eq(0)
      end
    end

    context "when points have no elevation change" do
      before do
        ride.points << Point.new(:time => Time.at(1000), :elevation => 1000, :latitude => 39.366613000, :longitude => -105.352029000)
        ride.points << Point.new(:time => Time.at(2000), :elevation => 1000, :latitude => 39.384598000, :longitude => -105.274850000)
      end

      it "correctly computes the elapsed time between points with no elevation change" do
        Gpx::Statistics::RideStatistics.flat_duration(ride).should eq(1000.0)
      end
    end
  end

  describe ".average_pace" do
    context "when no points exist" do
      it "is zero" do
        Gpx::Statistics::RideStatistics.average_pace(ride).should eq(0)
      end
    end

    context "when one point exists" do
      before do
        ride.points << Point.new(:latitude => 39.369981, :longitude => -105.338548, :time => Time.at(1000))
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.average_pace(ride).should eq(0)
      end
    end

    context "when inactive" do
      before do
        ride.points << Point.new(:latitude => 39.369981, :longitude => -105.338548, :time => Time.at(1000))
        ride.points << Point.new(:latitude => 39.370139, :longitude => -105.338413, :time => Time.at(2000))
        ride.points << Point.new(:latitude => 39.370302, :longitude => -105.338519, :time => Time.at(3000))
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.average_pace(ride).should eq(0)
      end
    end

    context "when active" do
      before do
        ride.points << Point.new(:latitude => 39.369981, :longitude => -105.338548, :time => Time.at(1000))
        ride.points << Point.new(:latitude => 39.370139, :longitude => -105.338413, :time => Time.at(1012))
        ride.points << Point.new(:latitude => 39.370302, :longitude => -105.338519, :time => Time.at(1034))
        ride.points << Point.new(:latitude => 39.370149, :longitude => -105.339224, :time => Time.at(10000))
      end

      it "correctly computes the average pace between points" do
        Gpx::Statistics::RideStatistics.average_pace(ride).should be_within(0.0000001).of(0.3267437)
      end

      it "sets the pace on the points" do
        Gpx::Statistics::RideStatistics.average_pace(ride)
        ride.points.first.pace.should eq(0)
        ride.points.second.pace.should be_within(0.0000001).of(0.5711815)
        ride.points.third.pace.should be_within(0.0000001).of(1.0868708)
        ride.points.last.pace.should eq(0)
      end
    end
  end

  describe ".average_ascending_pace" do
    context "when no points exist" do
      it "is zero" do
        Gpx::Statistics::RideStatistics.average_ascending_pace(ride).should eq(0)
      end
    end

    context "when one point exists" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1000)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.average_ascending_pace(ride).should eq(0)
      end
    end

    context "when all points are descending" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1000)
        ride.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 500)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.average_ascending_pace(ride).should eq(0)
      end
    end

    context "when points are ascending" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 500)
        ride.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)
        ride.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(3000), :elevation => 1500)
      end

      it "correctly computes the average pace between points" do
        Gpx::Statistics::RideStatistics.average_ascending_pace(ride).should be_within(0.0000001).of(0.0955483)
      end
    end
  end

  describe ".average_descending_pace" do
    context "when no points exist" do
      it "is zero" do
        Gpx::Statistics::RideStatistics.average_descending_pace(ride).should eq(0)
      end
    end

    context "when one point exists" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 500)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.average_descending_pace(ride).should eq(0)
      end
    end

    context "when all points are ascending" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 500)
        ride.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.average_descending_pace(ride).should eq(0)
      end
    end

    context "when points are descending" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1500)
        ride.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)
        ride.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(3000), :elevation => 500)
      end

      it "correctly computes the average pace between points" do
        Gpx::Statistics::RideStatistics.average_descending_pace(ride).should be_within(0.0000001).of(0.0955483)
      end
    end
  end

  describe ".average_flat_pace" do
    context "when no points exist" do
      it "is zero" do
        Gpx::Statistics::RideStatistics.average_flat_pace(ride).should eq(0)
      end
    end

    context "when one point exists" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 500)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.average_flat_pace(ride).should eq(0)
      end
    end

    context "when all points are ascending" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 500)
        ride.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.average_flat_pace(ride).should eq(0)
      end
    end

    context "when all points are descending" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1000)
        ride.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 500)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.average_flat_pace(ride).should eq(0)
      end
    end

    context "when points have no elevation change" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1000)
        ride.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)
        ride.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(3000), :elevation => 1000)
      end

      it "correctly computes the average pace between points" do
        Gpx::Statistics::RideStatistics.average_flat_pace(ride).should be_within(0.0000001).of(0.0955483)
      end
    end
  end

  describe ".average_speed" do
    context "when no points exist" do
      it "is zero" do
        Gpx::Statistics::RideStatistics.average_speed(ride).should eq(0)
      end
    end

    context "when one point exists" do
      before do
        ride.points << Point.new(:latitude => 39.369981, :longitude => -105.338548, :time => Time.at(1000))
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.average_speed(ride).should eq(0)
      end
    end

    context "when inactive" do
      before do
        ride.points << Point.new(:latitude => 39.369981, :longitude => -105.338548, :time => Time.at(1000))
        ride.points << Point.new(:latitude => 39.370139, :longitude => -105.338413, :time => Time.at(2000))
        ride.points << Point.new(:latitude => 39.370302, :longitude => -105.338519, :time => Time.at(3000))
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.average_speed(ride).should eq(0)
      end
    end

    context "when active" do
      before do
        ride.points << Point.new(:latitude => 39.369981, :longitude => -105.338548, :time => Time.at(1000))
        ride.points << Point.new(:latitude => 39.370139, :longitude => -105.338413, :time => Time.at(1012))
        ride.points << Point.new(:latitude => 39.370302, :longitude => -105.338519, :time => Time.at(1034))
        ride.points << Point.new(:latitude => 39.370149, :longitude => -105.339224, :time => Time.at(10000))
      end

      it "correctly computes the average speed between points" do
        Gpx::Statistics::RideStatistics.average_speed(ride).should be_within(0.0000001).of(3.0605021)
      end

      it "sets the speed on the points" do
        Gpx::Statistics::RideStatistics.average_speed(ride)
        ride.points.first.speed.should eq(0)
        ride.points.second.speed.should be_within(0.0000001).of(1.7507568)
        ride.points.third.speed.should be_within(0.0000001).of(0.9200725)
        ride.points.last.speed.should be_within(0.0000001).of(0.0070049)
      end
    end
  end

  describe ".average_ascending_speed" do
    context "when no points exist" do
      it "is zero" do
        Gpx::Statistics::RideStatistics.average_ascending_speed(ride).should eq(0)
      end
    end

    context "when one point exists" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1000)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.average_ascending_speed(ride).should eq(0)
      end
    end

    context "when all points are descending" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1500)
        ride.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)
        ride.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(3000), :elevation => 500)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.average_ascending_speed(ride).should eq(0)
      end
    end

    context "when points are ascending" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 500)
        ride.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)
        ride.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(3000), :elevation => 1500)
      end

      it "correctly computes the average speed between points" do
        Gpx::Statistics::RideStatistics.average_ascending_speed(ride).should be_within(0.0000001).of(10.4659019)
      end
    end
  end

  describe ".average_descending_speed" do
    context "when no points exist" do
      it "is zero" do
        Gpx::Statistics::RideStatistics.average_descending_speed(ride).should eq(0)
      end
    end

    context "when one point exists" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 500)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.average_descending_speed(ride).should eq(0)
      end
    end

    context "when all points are ascending" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 500)
        ride.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)
        ride.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(3000), :elevation => 1500)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.average_descending_speed(ride).should eq(0)
      end
    end

    context "when points are descending" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1500)
        ride.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)
        ride.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(3000), :elevation => 500)
      end

      it "correctly computes the average speed between points" do
        Gpx::Statistics::RideStatistics.average_descending_speed(ride).should be_within(0.0000001).of(10.4659019)
      end
    end
  end

  describe ".average_flat_speed" do
    context "when no points exist" do
      it "is zero" do
        Gpx::Statistics::RideStatistics.average_flat_speed(ride).should eq(0)
      end
    end

    context "when one point exists" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 500)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.average_flat_speed(ride).should eq(0)
      end
    end

    context "when all points are ascending" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 500)
        ride.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)
        ride.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(3000), :elevation => 1500)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.average_flat_speed(ride).should eq(0)
      end
    end

    context "when all points are descending" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1500)
        ride.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)
        ride.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(3000), :elevation => 500)
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.average_flat_speed(ride).should eq(0)
      end
    end

    context "when points have no elevation change" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1000)
        ride.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)
        ride.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(3000), :elevation => 1000)
      end

      it "correctly computes the average speed between points" do
        Gpx::Statistics::RideStatistics.average_flat_speed(ride).should be_within(0.0000001).of(10.4659019)
      end
    end
  end

  describe ".maximum_speed" do
    context "when no points exist" do
      it "is zero" do
        Gpx::Statistics::RideStatistics.maximum_speed(ride).should eq(0)
      end
    end

    context "when one point exists" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000))
      end

      it "is zero" do
        Gpx::Statistics::RideStatistics.maximum_speed(ride).should eq(0)
      end
    end

    context "when multiple points exist" do
      before do
        ride.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000))
        ride.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000))
        ride.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(3000))
      end

      it "correctly computes the maximum speed between points" do
        Gpx::Statistics::RideStatistics.maximum_speed(ride).should be_within(0.0000001).of(14.0183473)
      end
    end
  end

  describe ".average_heart_rate" do
    context "when no points exist" do
      it "is nil" do
        Gpx::Statistics::RideStatistics.average_heart_rate(ride).should be_nil
      end
    end

    context "when one point exists" do
      before do
        ride.points << Point.new(:heart_rate => 123)
      end

      it "is the heart rate value of the only point" do
        Gpx::Statistics::RideStatistics.average_heart_rate(ride).should eq(123)
      end
    end

    context "when multiple points exist" do
      context "when no heart rate data is present" do
        before do
          ride.points << Point.new
          ride.points << Point.new
          ride.points << Point.new
        end

        it "is nil" do
          Gpx::Statistics::RideStatistics.average_heart_rate(ride).should be_nil
        end
      end

      context "when heart rate data is present" do
        before do
          ride.points << Point.new(:heart_rate => 123)
          ride.points << Point.new(:heart_rate => 150)
          ride.points << Point.new(:heart_rate => 131)
        end

        it "correctly computes the average heart rate between points" do
          Gpx::Statistics::RideStatistics.average_heart_rate(ride).should be_within(0.0000001).of(134.6666666)
        end
      end
    end
  end

  describe "maximum_heart_rate" do
    context "when no points exist" do
      it "is nil" do
        Gpx::Statistics::RideStatistics.maximum_heart_rate(ride).should be_nil
      end
    end

    context "when one point exists" do
      before do
        ride.points << Point.new(:heart_rate => 123)
      end

      it "is the heart rate value of the only point" do
        Gpx::Statistics::RideStatistics.maximum_heart_rate(ride).should eq(123)
      end
    end

    context "when multiple points exist" do
      context "when no heart rate data is present" do
        before do
          ride.points << Point.new
          ride.points << Point.new
          ride.points << Point.new
        end

        it "is nil" do
          Gpx::Statistics::RideStatistics.maximum_heart_rate(ride).should be_nil
        end
      end

      context "when heart rate data is present" do
        before do
          ride.points << Point.new(:heart_rate => 123)
          ride.points << Point.new(:heart_rate => 150)
          ride.points << Point.new(:heart_rate => 131)
        end

        it "correctly computes the maximum heart rate between points" do
          Gpx::Statistics::RideStatistics.maximum_heart_rate(ride).should eq(150)
        end
      end
    end
  end
end
