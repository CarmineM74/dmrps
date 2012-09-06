class Location < ActiveRecord::Base
  attr_accessible :cap, :citta, :descrizione, :indirizzo, :provincia
  validates_presence_of :descrizione, :indirizzo, :cap, :citta, :provincia

  belongs_to :client, :inverse_of => :locations

end
