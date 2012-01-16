class RenameRecordColumns < ActiveRecord::Migration
  def change
    change_table :records do |t|
      t.rename :best_year, :best_year_distance
      t.rename :best_month, :best_month_distance
      t.rename :best_week, :best_week_distance
    end
  end
end
