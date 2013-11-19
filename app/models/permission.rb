class Permission < ActiveRecord::Base
  attr_accessible :rule, :status

  has_and_belongs_to_many :users
end
