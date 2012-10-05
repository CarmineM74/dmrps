class Location < ActiveRecord::Base
  attr_accessible :cap, :citta, :descrizione, :indirizzo, :provincia
  validates :descrizione, :indirizzo, :cap, :citta, :provincia, presence: true
  validates :descrizione, uniqueness: { scope: :client_id }

  belongs_to :client, :inverse_of => :locations
  has_and_belongs_to_many :interventions

end
