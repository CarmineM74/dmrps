require 'spec_helper'

describe Client do
  it "has a valid factory" do
    FactoryGirl.create(:client).should be_valid
  end
  
  context "Is not valid" do
    it "without ragione_sociale" do
      FactoryGirl.build(:client,ragione_sociale: nil).should_not be_valid
    end

    it "without either partita_iva or codice_fiscale" do
      FactoryGirl.build(:client,partita_iva: '', codice_fiscale: '').should_not be_valid
    end

    it "when codice_fiscale is not unique when present" do
      FactoryGirl.create(:client, codice_fiscale: 'ABC')
      FactoryGirl.build(:client, codice_fiscale: 'ABC').should_not be_valid
    end

    it "when tipo_contratto is neither 'Orario' nor 'Prestazione'" do
      FactoryGirl.build(:client, tipo_contratto: 'INVALID').should_not be_valid
    end

    it "when costo is < 0" do
      FactoryGirl.build(:client, costo: -1.0).should_not be_valid
    end

    it "when inizio > fine" do
      FactoryGirl.build(:client, inizio: 1.days.since, fine: Date.today).should_not be_valid
    end
  end
end

