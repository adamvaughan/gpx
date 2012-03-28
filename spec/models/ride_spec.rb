require 'spec_helper'

describe Ride do
  describe ".this_year" do
    let!(:first_ride) { Ride.create(:start_time => Time.now.utc.beginning_of_year) }
    let!(:second_ride) { Ride.create(:start_time => Time.now.utc.end_of_year) }
    let!(:third_ride) { Ride.create(:start_time => 1.year.ago) }
    let!(:fourth_ride) { Ride.create(:start_time => 1.year.from_now) }

    it "returns the rides from the current year" do
      Ride.this_year.should eq([second_ride, first_ride])
    end
  end

  describe ".total_distance_for_month" do
    let!(:first_ride) { Ride.create(:start_time => Time.now, :distance => 10) }
    let!(:second_ride) { Ride.create(:start_time => Time.now, :distance => 20) }
    let!(:third_ride) { Ride.create(:start_time => 1.month.ago, :distance => 30) }
    let!(:fourth_ride) { Ride.create(:start_time => 1.month.from_now, :distance => 40) }

    it "returns the total distance for rides in the given month" do
      Ride.total_distance_for_month(Date.today).should eq(30)
    end
  end

  describe ".total_distance_for_year" do
    let!(:first_ride) { Ride.create(:start_time => Time.now, :distance => 10) }
    let!(:second_ride) { Ride.create(:start_time => Time.now, :distance => 20) }
    let!(:third_ride) { Ride.create(:start_time => 1.year.ago, :distance => 30) }
    let!(:fourth_ride) { Ride.create(:start_time => 1.year.from_now, :distance => 40) }

    it "returns the total distance for rides in the given year" do
      Ride.total_distance_for_year(Date.today).should eq(30)
    end
  end

  describe ".total_duration_for_month" do
    let!(:first_ride) { Ride.create(:start_time => Time.now, :duration => 10) }
    let!(:second_ride) { Ride.create(:start_time => Time.now, :duration => 20) }
    let!(:third_ride) { Ride.create(:start_time => 1.month.ago, :duration => 30) }
    let!(:fourth_ride) { Ride.create(:start_time => 1.month.from_now, :duration => 40) }

    it "returns the total duration for rides in the given month" do
      Ride.total_duration_for_month(Date.today).should eq(30)
    end
  end

  describe ".total_duration_for_year" do
    let!(:first_ride) { Ride.create(:start_time => Time.now, :duration => 10) }
    let!(:second_ride) { Ride.create(:start_time => Time.now, :duration => 20) }
    let!(:third_ride) { Ride.create(:start_time => 1.year.ago, :duration => 30) }
    let!(:fourth_ride) { Ride.create(:start_time => 1.year.from_now, :duration => 40) }

    it "returns the total duration for rides in the given year" do
      Ride.total_duration_for_year(Date.today).should eq(30)
    end
  end
end
