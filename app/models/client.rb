class Client < ActiveRecord::Base
  
  TIPO_CONTRATTO = ['Orario', 'Prestazione']
  
  attr_accessible :ragione_sociale, :indirizzo, :citta, :cap, :provincia, :partita_iva, :codice_fiscale
  attr_accessible :tipo_contratto, :costo, :inizio, :fine, :diritto_di_chiamata, :costo_diritto_chiamata
  attr_accessible :nr_contratto

  validates_presence_of :ragione_sociale
  validates_uniqueness_of :ragione_sociale, :partita_iva
  validates_presence_of :partita_iva, :if => Proc.new { |c| c.codice_fiscale.nil? || c.codice_fiscale.empty? }
  validates :codice_fiscale, uniqueness: true, if: Proc.new { |c| !c.codice_fiscale.nil? }

  validates :tipo_contratto, :costo, :inizio, :fine, presence: true
  validates :costo, numericality: { greater_than_or_equal_to: 0 }
  validates :tipo_contratto, inclusion: Client::TIPO_CONTRATTO
  validate :inizio_must_be_less_than_or_equal_to_fine

  validates :costo_diritto_chiamata, numericality: { greater_than_or_equal_to: 0 }
  validates_presence_of :costo_diritto_chiamata, if: Proc.new { |c| c.diritto_di_chiamata }

  validates :nr_contratto, uniqueness: true, if: Proc.new { |c| !c.nr_contratto.nil? and !c.nr_contratto.empty? }

  has_many :locations, :inverse_of => :client, dependent: :delete_all

  has_many :contacts, :inverse_of => :client, dependent: :delete_all

  has_many :interventions, through: :locations

private

  def inizio_must_be_less_than_or_equal_to_fine
    errors.add(:inizio,"can't be greater than fine") if inizio > fine
  end

end
