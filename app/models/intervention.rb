class Intervention < ActiveRecord::Base

  attr_accessible :appunti, :contatto, :data_inoltro_richiesta, :data_intervento,
                  :descrizione_anomalie, :descrizione_intervento, :diritto_di_chiamata,
                  :email, :fine, :inizio, :lavoro_completato, :note, :ore_lavorate_cliente,
                  :ore_lavorate_laboratorio, :ore_lavorate_remoto, :user_id, :location_ids

  validates :data_inoltro_richiesta, presence: true
  validate :data_inoltro_richiesta, :data_inoltro_LE_data_intervento
  validates :data_intervento, presence: true
  validate :data_intervento, :data_intervento_GE_data_inoltro

  validates :inizio, presence: true
  validates :fine, presence: true

  validate :inizio, :check_intervallo_lavorato
  validate :fine, :check_intervallo_lavorato

  validates :descrizione_anomalie, presence: true
  validates :descrizione_intervento, presence: true
  validates :ore_lavorate_cliente, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :ore_lavorate_laboratorio, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :ore_lavorate_remoto, presence: true, numericality: { greater_than_or_equal_to: 0 }

  validates :lavoro_completato, presence: true
  validates :diritto_di_chiamata, presence: true

  belongs_to :user
  validate :user, :utente_assegnato

  has_and_belongs_to_many :locations
  validate :locations, :sede_assegnata

  def totale_ore_lavorate
    ore_lavorate_cliente + ore_lavorate_laboratorio + ore_lavorate_remoto
  end

private

  def utente_assegnato
    errors.add(:user,"must have an assigned user") if user.nil?
  end

  def sede_assegnata
    errors.add(:locations,"must have an assigned location") if locations.size != 1
  end

  def data_inoltro_LE_data_intervento
    errors.add(:data_inoltro_richiesta,"can't be greater than Data intervento") if data_inoltro_richiesta > data_intervento
  end

  def data_intervento_GE_data_inoltro
    errors.add(:data_intervento,"can't be less than Data inoltro richiesta") if data_intervento < data_inoltro_richiesta
  end

  def check_intervallo_lavorato
    errors.add(:inizio,"can't be greater than Fine") if inizio > fine
    errors.add(:fine,"can't be less than Inizio") if fine < inizio
    errors.add(:inizio,"can't be less than Data inoltro richiesta") if inizio < data_inoltro_richiesta
    errors.add(:fine,"can't be less than Data inoltro richiesta") if fine < data_inoltro_richiesta
  end

end
