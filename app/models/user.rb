class User < ActiveRecord::Base
  has_secure_password
  attr_accessible :email, :password, :password_confirmation
  validates_presence_of :password, :on => :create

  attr_reader :admin

  def admin
    !self.email.nil? && self.email == 'carmine@moleti.it'
  end

end