class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :year
      t.integer :month
      t.integer :week
      t.integer :year_ride_count
      t.decimal :year_distance, :precision => 20, :scale => 10
      t.decimal :year_duration, :precision => 20, :scale => 10
      t.decimal :year_elevation_gain, :precision => 20, :scale => 10
      t.decimal :month_distance, :precision => 20, :scale => 10
      t.decimal :month_duration, :precision => 20, :scale => 10
      t.integer :month_ride_count
      t.decimal :month_elevation_gain, :precision => 20, :scale => 10
      t.decimal :week_distance, :precision => 20, :scale => 10
      t.decimal :week_duration, :precision => 20, :scale => 10
      t.integer :week_ride_count
      t.decimal :week_elevation_gain, :precision => 20, :scale => 10
      t.timestamps
    end
  end
end
