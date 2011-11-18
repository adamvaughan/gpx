class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.references :best_segment
      t.decimal :best_year, :precision => 20, :scale => 10
      t.decimal :best_month, :precision => 20, :scale => 10
      t.decimal :best_week, :precision => 20, :scale => 10
      t.timestamps
    end
  end
end
