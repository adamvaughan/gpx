class Segment < ActiveRecord::Base
  has_many :points, :dependent => :destroy

  validates :name, :presence => true

  default_scope :order => 'start_time, created_at DESC'
end
