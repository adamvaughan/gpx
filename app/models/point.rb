class Point < ActiveRecord::Base
  belongs_to :segment

  default_scope :order => 'time, created_at'
end
