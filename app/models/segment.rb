class Segment < ActiveRecord::Base
  has_many :points, :dependent => :delete_all

  validates :name, :presence => true

  default_scope :order => 'start_time DESC, created_at DESC'

  attr_accessible :name
end
