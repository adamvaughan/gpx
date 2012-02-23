class AddHeartRateToPoints < ActiveRecord::Migration
  def change
    change_table :points do |t|
      t.integer :heart_rate
    end
  end
end
