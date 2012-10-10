require 'spec_helper'

describe Intervention do
  it "has a valid factory" do
    intervention = FactoryGirl.create(:intervention)
    intervention.should be_valid
  end

  context "Is invalid" do
    it "is invalid without a location" do
      intervention = FactoryGirl.create(:intervention,locations: [])
      intervention.should_not be_valid
    end

    it "is invalid when Data Inoltro Richiesta is > Data Intervento"

    it "is invalid when Inizio is >= Fine"

    it "is invalid when Descrizione anomalie is empty"

    it "is invalid when Descrizione intervento is empty"

    it "is invalid when Ore lavorate cliente is < 0"

    it "is invalid when Ore lavorate remoto is < 0"

    it "is invalid when Ore lavorate laboratorio is < 0"
  end

end

