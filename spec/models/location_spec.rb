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
    client2 = FactoryGirl.create(:client, partita_iva: '00', codice_fiscale: '00')
    location_details = JSON.parse(FactoryGirl.build(:location,client: nil).to_json(except: [:id,:created_at,:updated_at,:client_id]))
    location2_details = JSON.parse(FactoryGirl.build(:location,client: nil,descrizione: location_details['descrizione']).to_json(except: [:id,:created_at,:updated_at,:client_id]))
    l1 = client.locations.create(location_details)
    l1.should be_valid
    l2 = client.locations.create(location2_details)
    l2.should_not be_valid
    l3 = client2.locations.create(location2_details)
    l3.should be_valid
  end

end
