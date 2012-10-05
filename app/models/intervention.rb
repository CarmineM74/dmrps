class Intervention < ActiveRecord::Base

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
  validates :ore_lavorate_cliente, presence: true, numericality: true
  validates :ore_lavorate_laboratorio, presence: true, numericality: true
  validates :ore_lavorate_remoto, presence: true, numericality: true

  validates :lavoro_completato, presence: true
  validates :diritto_di_chiamata, presence: true

  belongs_to :user
  has_and_belongs_to_many :locations

private

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
