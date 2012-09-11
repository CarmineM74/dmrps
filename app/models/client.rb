class Client < ActiveRecord::Base
  attr_accessible :ragione_sociale, :indirizzo, :citta, :cap, :provincia, :partita_iva, :codice_fiscale
  validates_presence_of :ragione_sociale
  validates_uniqueness_of :ragione_sociale, :partita_iva, :on => :create
  validates_presence_of :partita_iva, :if => Proc.new { |c| c.codice_fiscale.nil? || c.codice_fiscale.empty? }
  validates_uniqueness_of :codice_fiscale, :if => Proc.new { |c| !c.codice_fiscale.nil? }
  has_many :locations, :inverse_of => :client

end
