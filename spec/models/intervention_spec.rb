require 'spec_helper'

describe Intervention do
  it "has a valid factory" do
    intervention = FactoryGirl.create(:intervention)
    intervention.should be_valid
  end

  context "Is invalid" do
    it "is invalid without a location" do
      intervention = FactoryGirl.create(:intervention)
      intervention.locations = []
      intervention.should_not be_valid
    end

    it "when Data Inoltro Richiesta is > Data Intervento" do
      intervention = FactoryGirl.build(:intervention)
      intervention.data_inoltro_richiesta = intervention.data_intervento + 10
      intervention.should_not be_valid
    end

    it "when Inizio is >= Fine"

    it "when Descrizione anomalie is empty"

    it "when Descrizione intervento is empty"

    it "when Ore lavorate cliente is < 0"

    it "when Ore lavorate remoto is < 0"

    it "when Ore lavorate laboratorio is < 0"
  end

end

