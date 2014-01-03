class User < ActiveRecord::Base
  ROLES = %w[admin user client]

  has_secure_password

  attr_accessible :email, :role

  validates_presence_of :email
  validates_uniqueness_of :email
  validates :role, inclusion: { in: ROLES }
  validates :password, :password_confirmation, presence: true, if: :validate_password?

  has_and_belongs_to_many :permissions
  has_many :interventions

  has_many :collaborations
  has_many :partecipations, through: :collaborations, source: :intervention

  def admin?
    self.role == 'admin'
  end

  def user?
    self.role == 'user'
  end

  def client?
    self.role == 'client'
  end

private

  def validate_password?
    password.present?
  end

end
