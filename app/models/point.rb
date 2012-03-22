class Point < ActiveRecord::Base
  belongs_to :ride, :touch => true

  default_scope :order => 'time, created_at'
end
