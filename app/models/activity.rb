class Activity < ActiveRecord::Base
  attr_accessible :descrizione

  validates :descrizione, presence: true

  has_and_belongs_to_many :interventions

end
