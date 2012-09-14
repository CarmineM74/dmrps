require 'spec_helper'

shared_examples_for "requires a client" do
  it "fetches a client by client_id" do
    Client.should_receive(:find).with(client.id.to_s) { client }
    do_verb
  end

  it "fails with status == :not_found if client_id can't be found" do
    client.id = 200
    do_verb
    last_response.status.should eq(404)
  end
end

describe "/api/v1/clients/:client_id/locations.json", :type => :api do
  let(:client) { FactoryGirl.create(:client) }
  let(:url) { "/api/v1/locations" }
  
  describe 'Locations index' do
    it_behaves_like "requires a client"

    def do_verb
      get url+".json", client_id: client.id
    end

    describe "fetches all locations for a given client" do
      it "returns an empty array of locations when client has no locations" do
        do_verb
        body = JSON.parse(last_response.body)
        body.should eq([])
      end
      
      it "returns an array with client's locations" do
        location = FactoryGirl.create(:location)
        client.locations << location
        client.save
        do_verb
        body = JSON.parse(last_response.body)
        body.should eq([JSON.parse(location.to_json(except: [:client_id,:created_at,:updated_at]))])
      end
    end

  end

  describe 'Creating a location' do
    it_behaves_like "requires a client"

    let(:location) { FactoryGirl.build(:location) }

    def do_verb
      @post_params = JSON.parse(location.to_json(except: [:id, :client_id, :created_at, :updated_at]))
      post url+".json", client_id: client.id, location: @post_params
    end

    context "with valid parameters for location" do
      it "creates a new location for a given client" do
        do_verb
        client.reload
        l = client.locations.find_by_descrizione(location.descrizione)
        l = JSON.parse(l.to_json(except: [:id, :client_id, :created_at, :updated_at]))
        l.should eq(@post_params)
      end
      it "replies with status == :created (201)"
      it "replies with location's details"
    end

    context "with invalid parameters for location" do
    end

  end

  describe 'Updating a location' do
  end

  describe 'Deleting a location' do
  end

end
