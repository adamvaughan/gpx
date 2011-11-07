class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.decimal :latitude, :precision => 20, :scale => 10
      t.decimal :longitude, :precision => 20, :scale => 10
      t.decimal :elevation, :precision => 20, :scale => 10
      t.datetime :time

      t.references :segment
      t.timestamps
    end
  end
end
