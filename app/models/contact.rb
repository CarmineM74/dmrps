class Contact < ActiveRecord::Base
  attr_accessible :email, :name, :notes, :phone

  validates :name, presence: true

  belongs_to :client, inverse_of: :contacts

end
