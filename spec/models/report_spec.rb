require 'spec_helper'

describe Report do
  describe ".current" do
    context "when a report does not already exist" do
      let(:report) { Report.current }

      it "sets the report date on the created report" do
        report.year.should eq(Date.today.year)
        report.month.should eq(Date.today.month)
        report.week.should eq(Date.today.cweek)
      end

      it "returns the created report" do
        report.should be_persisted
      end
    end

    context "when a report already exists" do
      let!(:existing_report) { Report.create(:year => 1.year.ago.year, :month => 1.month.ago.month, :week => 1.week.ago.to_date.cweek) }
      let(:report) { Report.current }

      it "updates the report date on the existing report" do
        report.year.should eq(Date.today.year)
        report.month.should eq(Date.today.month)
        report.week.should eq(Date.today.cweek)
      end

      it "returns the existing report" do
        report.id.should eq(existing_report.id)
      end
    end
  end

  describe "#year=" do
    let(:report) { Report.new(:year => 2012, :year_ride_count => 1, :year_distance => 1, :year_duration => 1, :year_elevation_gain => 1) }

    context "when the year value is not changed" do
      before do
        report.year = 2012
      end

      it "leaves all year totals the same" do
        report.year.should eq(2012)
        report.year_ride_count.should eq(1)
        report.year_distance.should eq(1)
        report.year_duration.should eq(1)
        report.year_elevation_gain.should eq(1)
      end
    end

    context "when the year value is changed" do
      before do
        report.year = 2013
      end

      it "resets all year totals to zero" do
        report.year.should eq(2013)
        report.year_ride_count.should eq(0)
        report.year_distance.should eq(0)
        report.year_duration.should eq(0)
        report.year_elevation_gain.should eq(0)
      end
    end
  end

  describe "#month=" do
    let(:report) { Report.new(:month => 1, :month_ride_count => 1, :month_distance => 1, :month_duration => 1, :month_elevation_gain => 1) }

    context "when the month value is not changed" do
      before do
        report.month = 1
      end

      it "leaves all month totals the same" do
        report.month.should eq(1)
        report.month_ride_count.should eq(1)
        report.month_distance.should eq(1)
        report.month_duration.should eq(1)
        report.month_elevation_gain.should eq(1)
      end
    end

    context "when the month value is changed" do
      before do
        report.month = 2
      end

      it "resets all month totals to zero" do
        report.month.should eq(2)
        report.month_ride_count.should eq(0)
        report.month_distance.should eq(0)
        report.month_duration.should eq(0)
        report.month_elevation_gain.should eq(0)
      end
    end
  end

  describe "week=" do
    let(:report) { Report.new(:week => 1, :week_ride_count => 1, :week_distance => 1, :week_duration => 1, :week_elevation_gain => 1) }

    context "when the week value is not changed" do
      before do
        report.week = 1
      end

      it "leaves all week totals the same" do
        report.week.should eq(1)
        report.week_ride_count.should eq(1)
        report.week_distance.should eq(1)
        report.week_duration.should eq(1)
        report.week_elevation_gain.should eq(1)
      end
    end

    context "when the week value is changed" do
      before do
        report.week = 2
      end

      it "resets all week totals to zero" do
        report.week.should eq(2)
        report.week_ride_count.should eq(0)
        report.week_distance.should eq(0)
        report.week_duration.should eq(0)
        report.week_elevation_gain.should eq(0)
      end
    end
  end
end
