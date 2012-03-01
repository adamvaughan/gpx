class Point < ActiveRecord::Base
  belongs_to :segment, :touch => true

  default_scope :order => 'time, created_at'
end
