require 'spec_helper'

describe Gpx::Reports::ReportGenerator do
  let(:report) { Report.new }

  describe ".update_year_totals" do
    context "when no rides exist" do
      before do
        Gpx::Reports::ReportGenerator.update_year_totals([], report)
      end

      it "sets year totals to zero" do
        report.year_distance.should eq(0)
        report.year_duration.should eq(0)
        report.year_elevation_gain.should eq(0)
        report.year_ride_count.should eq(0)
      end
    end

    context "when rides exist" do
      let(:first_ride) { Ride.new(:distance => 10, :active_duration => 15, :elevation_gain => 100) }
      let(:second_ride) { Ride.new(:distance => 20, :active_duration => 25, :elevation_gain => 200) }
      let(:third_ride) { Ride.new(:distance => 30, :active_duration => 35, :elevation_gain => 300) }
      let(:rides) { [first_ride, second_ride, third_ride] }

      before do
        Gpx::Reports::ReportGenerator.update_year_totals(rides, report)
      end

      it "correctly calculates the year totals" do
        report.year_distance.should eq(60)
        report.year_duration.should eq(75)
        report.year_elevation_gain.should eq(600)
        report.year_ride_count.should eq(3)
      end
    end
  end

  describe ".update_month_totals" do
    context "when no rides exist" do
      before do
        Gpx::Reports::ReportGenerator.update_month_totals([], report)
      end

      it "sets month totals to zero" do
        report.month_distance.should eq(0)
        report.month_duration.should eq(0)
        report.month_elevation_gain.should eq(0)
        report.month_ride_count.should eq(0)
      end
    end

    context "when rides exist" do
      let(:first_ride) { Ride.new(:start_time => Time.now, :distance => 10, :active_duration => 15, :elevation_gain => 100) }
      let(:second_ride) { Ride.new(:start_time => Time.now, :distance => 20, :active_duration => 25, :elevation_gain => 200) }
      let(:third_ride) { Ride.new(:start_time => 1.month.from_now, :distance => 30, :active_duration => 35, :elevation_gain => 300) }
      let(:fourth_ride) { Ride.new(:start_time => 1.month.ago, :distance => 40, :active_duration => 45, :elevation_gain => 400) }
      let(:rides) { [first_ride, second_ride, third_ride, fourth_ride] }

      before do
        Gpx::Reports::ReportGenerator.update_month_totals(rides, report)
      end

      it "correctly calculates the month totals" do
        report.month_distance.should eq(30)
        report.month_duration.should eq(40)
        report.month_elevation_gain.should eq(300)
        report.month_ride_count.should eq(2)
      end
    end
  end

  describe ".update_week_totals" do
    context "when no rides exist" do
      before do
        Gpx::Reports::ReportGenerator.update_week_totals([], report)
      end

      it "sets week totals to zero" do
        report.week_distance.should eq(0)
        report.week_duration.should eq(0)
        report.week_elevation_gain.should eq(0)
        report.week_ride_count.should eq(0)
      end
    end

    context "when rides exist" do
      let(:first_ride) { Ride.new(:start_time => Time.now, :distance => 10, :active_duration => 15, :elevation_gain => 100) }
      let(:second_ride) { Ride.new(:start_time => Time.now, :distance => 20, :active_duration => 25, :elevation_gain => 200) }
      let(:third_ride) { Ride.new(:start_time => 1.week.from_now, :distance => 30, :active_duration => 35, :elevation_gain => 300) }
      let(:fourth_ride) { Ride.new(:start_time => 1.week.ago, :distance => 40, :active_duration => 45, :elevation_gain => 400) }
      let(:rides) { [first_ride, second_ride, third_ride, fourth_ride] }

      before do
        Gpx::Reports::ReportGenerator.update_week_totals(rides, report)
      end

      it "correctly calculates the week totals" do
        report.week_distance.should eq(30)
        report.week_duration.should eq(40)
        report.week_elevation_gain.should eq(300)
        report.week_ride_count.should eq(2)
      end
    end
  end
end
