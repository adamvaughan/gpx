class AddHeartRateFieldsToSegment < ActiveRecord::Migration
  def change
    change_table :segments do |t|
      t.integer :maximum_heart_rate
      t.decimal :average_heart_rate, :precision => 20, :scale => 10
    end
  end
end
