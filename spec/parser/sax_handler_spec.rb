require 'spec_helper'

describe Gpx::Parser::SaxHandler do
  let(:handler) { Gpx::Parser::SaxHandler.new }

  before do
    xml = %{
      <?xml version="1.0" encoding="UTF-8"?>
      <gpx version="1.1" creator="RunKeeper - http://www.runkeeper.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.topografix.com/GPX/1/1" xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd">
        <trk>
          <name><![CDATA[Mountain Biking 10/30/11 1:07 pm]]></name>
          <time>2011-10-30T13:07:40Z</time>
          <trkseg>
            <trkpt lat="39.385208000" lon="-105.274872000">
              <ele>2047.5</ele>
              <time>2011-10-30T13:07:34Z</time>
            </trkpt>
          </trkseg>
        </trk>
      </gpx>
    }

    Ox.sax_parse(handler, StringIO.new(xml))
  end

  it "parses track name into segment" do
    handler.segments.first.name.should eq('Mountain Biking 10/30/11 1:07 pm')
  end

  it "parses track segments" do
    handler.segments.should have(1).item
  end

  it "parses track segment points" do
    handler.segments.first.points.should have(1).items
  end

  it "parses track point latitude" do
    handler.segments.first.points.first.latitude.should eq(39.385208000)
  end

  it "parses track point longitude" do
    handler.segments.first.points.first.longitude.should eq(-105.274872000)
  end

  it "parses track point elevation" do
    handler.segments.first.points.first.elevation.should eq(2047.5)
  end

  it "parses track point time" do
    handler.segments.first.points.first.time.to_s.should eq('2011-10-30 13:07:34 UTC')
  end
end
