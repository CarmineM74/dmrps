class User < ActiveRecord::Base
  ROLES = %w[admin user client]

  has_secure_password
  attr_accessible :email, :password, :password_confirmation, :role
  validates_presence_of :email, :password
  validates_uniqueness_of :email

  validates :role, inclusion: { in: ROLES }

  has_many :interventions

  def admin?
    self.role == 'admin'
  end

  def user?
    self.role == 'user'
  end

  def client?
    self.role == 'client'
  end

end
