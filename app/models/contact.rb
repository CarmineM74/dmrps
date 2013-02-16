class Contact < ActiveRecord::Base
  attr_accessible :email, :name, :notes, :phone

  belongs_to :location

end
