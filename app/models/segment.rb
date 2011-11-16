class Segment < ActiveRecord::Base
  has_many :points, :dependent => :delete_all

  validates :name, :presence => true

  default_scope :order => 'start_time DESC, created_at DESC'
  scope :this_year, where(:start_time => Time.now.utc.beginning_of_year..Time.now.utc.end_of_year)

  attr_accessible :name
end
