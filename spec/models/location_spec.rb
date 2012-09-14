require 'spec_helper'

describe Location do
  it "has a valid factory" do
    FactoryGirl.create(:location).should be_valid
  end

  it "requires: descrizione, indirizzo, cap, citta, provincia" do
    [:descrizione=,:indirizzo=,:cap=,:citta=,:provincia=].each do |attr|
      location = FactoryGirl.build(:location)
      location.send(attr,'')
      location.should_not be_valid
    end
  end

  it "descrizione must be unique within each client's scope" do
    client = FactoryGirl.create(:client)
    client.locations.create(FactoryGirl.build(:location))
  end

end
