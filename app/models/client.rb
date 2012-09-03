class Client < ActiveRecord::Base
  attr_accessible :ragione_sociale, :indirizzo, :citta, :cap, :provincia, :partita_iva, :codice_fiscale
  validates_presence_of :ragione_sociale, :on => :create
  validates_presence_of :partita_iva, :on => :create, :if => Proc.new { |c| c.codice_fiscale.nil? || c.codice_fiscale.empty? }

end
