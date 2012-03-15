class AddElevationTotalsToReports < ActiveRecord::Migration
  def change
    change_table :reports do |t|
      t.decimal :year_elevation_gain, :precision => 20, :scale => 10
      t.decimal :month_elevation_gain, :precision => 20, :scale => 10
      t.decimal :week_elevation_gain, :precision => 20, :scale => 10
    end
  end
end
