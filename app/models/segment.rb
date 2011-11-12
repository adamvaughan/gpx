class Segment < ActiveRecord::Base
  has_many :points, :dependent => :destroy

  validates :name, :presence => true

  default_scope :order => 'start_time DESC, created_at DESC'

  attr_accessible :name
end
