class Client < ActiveRecord::Base
  attr_accessible :ragione_sociale, :indirizzo, :citta, :cap, :provincia, :partita_iva, :codice_fiscale
  validates_presence_of :ragione_sociale
  validates_uniqueness_of :ragione_sociale, :partita_iva
  validates_presence_of :partita_iva, :if => Proc.new { |c| c.codice_fiscale.nil? || c.codice_fiscale.empty? }
  validates :codice_fiscale, uniqueness: true, if: Proc.new { |c| !c.codice_fiscale.nil? }
  has_many :locations, :inverse_of => :client

end
