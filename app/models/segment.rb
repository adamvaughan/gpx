class Segment < ActiveRecord::Base
  has_many :points, :dependent => :destroy

  validates :name, :presence => true

  # Compares two segments for order based on start time.
  def <=>(other)
    start_time <=> other.start_time
  end
end
