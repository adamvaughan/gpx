class Ride < ActiveRecord::Base
  has_many :points, :dependent => :delete_all

  default_scope :order => 'start_time DESC, created_at DESC'
  scope :this_year, where(:start_time => Time.now.utc.beginning_of_year..Time.now.utc.end_of_year)

  def self.total_distance_for_month(date)
    where(:start_time => date.to_time.utc.beginning_of_month..date.to_time.utc.end_of_month).sum(:distance)
  end

  def self.total_distance_for_year(date)
    where(:start_time => date.to_time.utc.beginning_of_year..date.to_time.utc.end_of_year).sum(:distance)
  end

  def self.total_duration_for_month(date)
    where(:start_time => date.to_time.utc.beginning_of_month..date.to_time.utc.end_of_month).sum(:duration)
  end

  def self.total_duration_for_year(date)
    where(:start_time => date.to_time.utc.beginning_of_year..date.to_time.utc.end_of_year).sum(:duration)
  end
end
