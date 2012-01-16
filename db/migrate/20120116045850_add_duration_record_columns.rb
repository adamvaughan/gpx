class AddDurationRecordColumns < ActiveRecord::Migration
  def change
    change_table :records do |t|
      t.decimal :best_year_duration, :precision => 20, :scale => 10
      t.decimal :best_month_duration, :precision => 20, :scale => 10
      t.decimal :best_week_duration, :precision => 20, :scale => 10
    end
  end
end
