require 'spec_helper'

describe Segment do
  let(:segment) { Segment.new }

  describe "#distance" do
    it "is zero when no points exist" do
      segment.distance.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000)
      segment.distance.should eq(0)
    end

    it "correctly computes the distance between points" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000)
      segment.distance.should be_within(0.0000001).of(6936.4947082)
    end
  end

  describe "#ascending_distance" do
    it "is zero when no points exist" do
      segment.ascending_distance.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :elevation => 1000)
      segment.ascending_distance.should eq(0)
    end

    it "is zero when all points are descending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :elevation => 1000)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :elevation => 500)
      segment.ascending_distance.should eq(0)
    end

    it "correctly computes the distance between points when ascending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :elevation => 500)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :elevation => 1000)
      segment.ascending_distance.should be_within(0.0000001).of(6936.4947082)
    end
  end

  describe "#descending_distance" do
    it "is zero when no points exist" do
      segment.descending_distance.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :elevation => 500)
      segment.descending_distance.should eq(0)
    end

    it "is zero when all points are ascending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :elevation => 500)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :elevation => 1000)
      segment.descending_distance.should eq(0)
    end

    it "correctly computes the distance between points when descending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :elevation => 1000)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :elevation => 500)
      segment.descending_distance.should be_within(0.0000001).of(6936.4947082)
    end
  end

  describe "#flat_distance" do
    it "is zero when no points exist" do
      segment.flat_distance.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :elevation => 500)
      segment.flat_distance.should eq(0)
    end

    it "is zero when all points are ascending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :elevation => 500)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :elevation => 1000)
      segment.flat_distance.should eq(0)
    end

    it "is zero when all points are descending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :elevation => 1000)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :elevation => 500)
      segment.flat_distance.should eq(0)
    end

    it "correctly computes the distance between points with no elevation change" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :elevation => 1000)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :elevation => 1000)
      segment.flat_distance.should be_within(0.0000001).of(6936.4947082)
    end
  end

  describe "#elevation_gain" do
    it "is zero when no points exist" do
      segment.elevation_gain.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:elevation => 2044.1)
      segment.elevation_gain.should eq(0)
    end

    it "correctly computes the elevation gain between points" do
      segment.points << Point.new(:elevation => 2044.1)
      segment.points << Point.new(:elevation => 2047.9)
      segment.elevation_gain.should be_within(0.0000001).of(3.8)
    end
  end

  describe "#elevation_loss" do
    it "is zero when no points exist" do
      segment.elevation_loss.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:elevation => 2047.9)
      segment.elevation_loss.should eq(0)
    end

    it "correctly computes the elevation loss between points" do
      segment.points << Point.new(:elevation => 2047.9)
      segment.points << Point.new(:elevation => 2044.1)
      segment.elevation_loss.should be_within(0.0000001).of(3.8)
    end
  end

  describe "#elevation_change" do
    it "is zero when no points exist" do
      segment.elevation_change.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:elevation => 2047.9)
      segment.elevation_change.should eq(0)
    end

    it "correctly computes the elevation change between points" do
      segment.points << Point.new(:elevation => 2047.9)
      segment.points << Point.new(:elevation => 2044.1)
      segment.points << Point.new(:elevation => 2045.6)
      segment.elevation_change.should be_within(0.0000001).of(-2.3)
    end
  end

  describe "#duration" do
    it "is zero when no points exist" do
      segment.duration.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:time => Time.at(1000))
      segment.duration.should eq(0)
    end

    it "correctly computes the duration between points" do
      segment.points << Point.new(:time => Time.at(1000))
      segment.points << Point.new(:time => Time.at(2000))
      segment.duration.should be_within(0.0000001).of(1000.0)
    end
  end

  describe "#active_duration" do
    it "is zero when no points exist" do
      segment.active_duration.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:latitude => 39.369981, :longitude => -105.338548, :time => Time.at(1000))
      segment.active_duration.should eq(0)
    end

    it "is zero when the speed between points does not get above 0.5 m/s" do
      segment.points << Point.new(:latitude => 39.369981, :longitude => -105.338548, :time => Time.at(1000))
      segment.points << Point.new(:latitude => 39.370139, :longitude => -105.338413, :time => Time.at(2000))
      segment.points << Point.new(:latitude => 39.370302, :longitude => -105.338519, :time => Time.at(3000))
      segment.active_duration.should eq(0)
    end

    it "correctly computes the duration between points when active" do
      segment.points << Point.new(:latitude => 39.369981, :longitude => -105.338548, :time => Time.at(1000))
      segment.points << Point.new(:latitude => 39.370139, :longitude => -105.338413, :time => Time.at(1012))
      segment.points << Point.new(:latitude => 39.370302, :longitude => -105.338519, :time => Time.at(1034))
      segment.points << Point.new(:latitude => 39.370149, :longitude => -105.339224, :time => Time.at(10000))
      segment.active_duration.should eq(34.0)
    end
  end

  describe "#ascending_duration" do
    it "is zero when no points exist" do
      segment.ascending_duration.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:time => Time.at(1000), :elevation => 1000)
      segment.ascending_duration.should eq(0)
    end

    it "is zero when all points are descending" do
      segment.points << Point.new(:time => Time.at(1000), :elevation => 1000)
      segment.points << Point.new(:time => Time.at(2000), :elevation => 500)
      segment.ascending_duration.should eq(0)
    end

    it "correctly computes the elapsed time between points when ascending" do
      segment.points << Point.new(:time => Time.at(1000), :elevation => 500)
      segment.points << Point.new(:time => Time.at(2000), :elevation => 1000)
      segment.ascending_duration.should eq(1000.0)
    end
  end

  describe "#descending_duration" do
    it "is zero when no points exist" do
      segment.descending_duration.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:time => Time.at(1000), :elevation => 500)
      segment.descending_duration.should eq(0)
    end

    it "is zero when all points are ascending" do
      segment.points << Point.new(:time => Time.at(1000), :elevation => 500)
      segment.points << Point.new(:time => Time.at(2000), :elevation => 1000)
      segment.descending_duration.should eq(0)
    end

    it "correctly computes the elapsed time between points when descending" do
      segment.points << Point.new(:time => Time.at(1000), :elevation => 1000)
      segment.points << Point.new(:time => Time.at(2000), :elevation => 500)
      segment.descending_duration.should eq(1000.0)
    end
  end

  describe "#flat_duration" do
    it "is zero when no points exist" do
      segment.flat_duration.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:time => Time.at(1000), :elevation => 500)
      segment.flat_duration.should eq(0)
    end

    it "is zero when all points are ascending" do
      segment.points << Point.new(:time => Time.at(1000), :elevation => 500)
      segment.points << Point.new(:time => Time.at(2000), :elevation => 1000)
      segment.flat_duration.should eq(0)
    end

    it "is zero when all points are descending" do
      segment.points << Point.new(:time => Time.at(1000), :elevation => 1000)
      segment.points << Point.new(:time => Time.at(2000), :elevation => 500)
      segment.flat_duration.should eq(0)
    end

    it "correctly computes the elapsed time between points with no elevation change" do
      segment.points << Point.new(:time => Time.at(1000), :elevation => 1000)
      segment.points << Point.new(:time => Time.at(2000), :elevation => 1000)
      segment.flat_duration.should eq(1000.0)
    end
  end

  describe "#average_pace" do
    it "is zero when no points exist" do
      segment.average_pace.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000))
      segment.average_pace.should eq(0)
    end

    it "correctly computes the average pace between points" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000))
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(20000))
      segment.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(300000))
      segment.average_pace.should be_within(0.0000001).of(7.5489584)
    end
  end

  describe "#average_ascending_pace" do
    it "is zero when no points exist" do
      segment.average_ascending_pace.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1000)
      segment.average_ascending_pace.should eq(0)
    end

    it "is zero when all points are descending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1000)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 500)
      segment.average_ascending_pace.should eq(0)
    end

    it "correctly computes the average pace between points when ascending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 500)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(20000), :elevation => 1000)
      segment.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(300000), :elevation => 1500)
      segment.average_ascending_pace.should be_within(0.0000001).of(7.5489584)
    end
  end

  describe "#average_descending_pace" do
    it "is zero when no points exist" do
      segment.average_descending_pace.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 500)
      segment.average_descending_pace.should eq(0)
    end

    it "is zero when all points are ascending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 500)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)
      segment.average_descending_pace.should eq(0)
    end

    it "correctly computes the average pace between points when descending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1500)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(20000), :elevation => 1000)
      segment.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(300000), :elevation => 500)
      segment.average_descending_pace.should be_within(0.0000001).of(7.5489584)
    end
  end

  describe "#average_flat_pace" do
    it "is zero when no points exist" do
      segment.average_flat_pace.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 500)
      segment.average_flat_pace.should eq(0)
    end

    it "is zero when all points are ascending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 500)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)
      segment.average_flat_pace.should eq(0)
    end

    it "is zero when all points are descending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1000)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 500)
      segment.average_flat_pace.should eq(0)
    end

    it "correctly computes the average pace between points with no elevation change" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1000)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(20000), :elevation => 1000)
      segment.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(300000), :elevation => 1000)
      segment.average_flat_pace.should be_within(0.0000001).of(7.5489584)
    end
  end

  describe "#average_speed" do
    it "is zero when no points exist" do
      segment.average_speed.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000))
      segment.average_speed.should eq(0)
    end

    it "correctly computes the average speed between points" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000))
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000))
      segment.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(3000))
      segment.average_speed.should be_within(0.0000001).of(7.0004587)
    end
  end

  describe "#average_ascending_speed" do
    it "is zero when no points exist" do
      segment.average_ascending_speed.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1000)
      segment.average_ascending_speed.should eq(0)
    end

    it "is zero when all points are descending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1500)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)
      segment.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(3000), :elevation => 500)
      segment.average_ascending_speed.should eq(0)
    end

    it "correctly computes the average speed between points when ascending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 500)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)
      segment.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(3000), :elevation => 1500)
      segment.average_ascending_speed.should be_within(0.0000001).of(7.0004587)
    end
  end

  describe "#average_descending_speed" do
    it "is zero when no points exist" do
      segment.average_descending_speed.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 500)
      segment.average_descending_speed.should eq(0)
    end

    it "is zero when all points are ascending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 500)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)
      segment.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(3000), :elevation => 1500)
      segment.average_descending_speed.should eq(0)
    end

    it "correctly computes the average speed between points when descending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1500)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)
      segment.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(3000), :elevation => 500)
      segment.average_descending_speed.should be_within(0.0000001).of(7.0004587)
    end
  end

  describe "#average_flat_speed" do
    it "is zero when no points exist" do
      segment.average_flat_speed.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 500)
      segment.average_flat_speed.should eq(0)
    end

    it "is zero when all points are ascending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 500)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)
      segment.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(3000), :elevation => 1500)
      segment.average_flat_speed.should eq(0)
    end

    it "is zero when all points are descending" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1500)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)
      segment.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(3000), :elevation => 500)
      segment.average_flat_speed.should eq(0)
    end

    it "correctly computes the average speed between points with no elevation change" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000), :elevation => 1000)
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000), :elevation => 1000)
      segment.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(3000), :elevation => 1000)
      segment.average_flat_speed.should be_within(0.0000001).of(7.0004587)
    end
  end

  describe "#maximum_speed" do
    it "is zero when no points exist" do
      segment.maximum_speed.should eq(0)
    end

    it "is zero when one point exists" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000))
      segment.maximum_speed.should eq(0)
    end

    it "correctly computes the maximum speed between points" do
      segment.points << Point.new(:latitude => 39.366613000, :longitude => -105.352029000, :time => Time.at(1000))
      segment.points << Point.new(:latitude => 39.384598000, :longitude => -105.274850000, :time => Time.at(2000))
      segment.points << Point.new(:latitude => 39.284698000, :longitude => -105.374860000, :time => Time.at(3000))
      segment.maximum_speed.should be_within(0.0000001).of(14.0648815)
    end
  end
end
