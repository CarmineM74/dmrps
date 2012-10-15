require 'spec_helper'

describe Intervention do
  it "has a valid factory" do
    @intervention = FactoryGirl.create(:intervention, user: FactoryGirl.create(:user))
    @intervention.should be_valid
  end

  context "Is invalid" do
    before(:each) do
      @intervention = FactoryGirl.build(:intervention)
    end

    after(:each) do
      @intervention.should_not be_valid
    end

    it "without a location" do
      @intervention.locations = []
    end

    it "without a user" do
      @intervention.user = nil
    end

    it "when Data Inoltro Richiesta is > Data Intervento" do
      @intervention.data_inoltro_richiesta = @intervention.data_intervento + 10
    end

    it "when Inizio is >= Fine" do
      @intervention.inizio = @intervention.fine + 1
    end

    it "when Inizio < Data inoltro richiesta" do
      @intervention.inizio = @intervention.data_inoltro_richiesta - 1
    end

    it "when Fine < Data inoltro richiesta" do
      @intervention.fine = @intervention.data_inoltro_richiesta - 1
    end

    it "when Descrizione anomalie is empty" do
      @intervention.descrizione_anomalie = ''
    end

    it "when Descrizione intervento is empty" do
      @intervention.descrizione_intervento = ''
    end

    it "when Ore lavorate cliente is < 0" do
      @intervention.ore_lavorate_cliente = -1
    end

    it "when Ore lavorate remoto is < 0" do
      @intervention.ore_lavorate_remoto = -1
    end

    it "when Ore lavorate laboratorio is < 0" do
      @intervention.ore_lavorate_laboratorio = -1
    end
  end

end

