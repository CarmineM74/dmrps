class Contract < ActiveRecord::Base
  TIPO_CONTRATTO = ['Orario','Prestazione']
  belongs_to :client, inverse_of: :contract
  attr_accessible :costo, :descrizione, :tipo, :inizio, :fine
  validates :descrizione, presence: true
  validates :tipo, presence: true
  validates :tipo, inclusion: Contract::TIPO_CONTRATTO
  validates :costo, presence: true, numericality: true
end
