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

describe "/api/v1/locations.json", :type => :api do
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
        location_params = location.attributes.except('created_at','updated_at')
        [:id,:client_id,:descrizione,:indirizzo,:citta,:cap,:provincia].each do |attr|
          location_params[attr].should eq(body[0][attr])
        end
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

    context "with valid parameter" do
      it "creates a new location for a given client" do
        do_verb
        client.reload
        l = client.locations.find_by_descrizione(location.descrizione)
        l.should_not be_nil
      end

      it "replies with status == :created (201)" do
        do_verb
        last_response.status.should eq(201)
      end

      it "replies with location's details" do
        do_verb
        body = JSON.parse(last_response.body)
        body["id"].should_not be_nil
        [:client_id, :descrizione,:indirizzo,:cap,:citta,:provincia].each do |a|
          @post_params[a].should eq(body[a])
        end
      end
    end

    context "with invalid parameters" do
      it "doesn't create a location" do
        location.descrizione = ''
        expect {
          do_verb
        }.to_not change(client.locations,:size)
      end

      it "replies with status == :unprocessable_entity (422)" do
        location.descrizione = ''
        do_verb
        last_response.status.should eq(422)
      end

      it "response's body contains errors" do
        location.descrizione = ''
        do_verb
        body = JSON.parse(last_response.body)
        body.should include('errors')
      end
    end

  end

  describe 'Updating a location' do
    it_behaves_like "requires a client"

    let(:location_attrs) { FactoryGirl.build(:location).attributes.except('id','client_id','created_at','updated_at') }
    let!(:location) { client.locations.create(location_attrs) }
    let(:put_url) { "#{url}/#{location.id}.json" }

    def do_verb
      put put_url, client_id: client.id, location: location_attrs
    end

    context "when the location doesn't exists" do
      it "fails with status == :not_found (404)" do
        location.id = 200
        do_verb
        last_response.status.should eq(404)
      end

      it "fails with error == 'resource not found'" do
        location.id = 200
        do_verb
        body = JSON.parse(last_response.body)
        body.should include('error_msg')
        body['error_msg'].should eq('resource not found')
      end
    end

    context "with valid parameters" do
      before(:each) { location_attrs["descrizione"] = 'updated' }

      it "updates location's details" do
        do_verb
        location.reload
        location.descrizione.should eq('updated')
      end

      it "replies with status == :ok (200)" do
        do_verb
        last_response.status.should eq(200)
      end

      it "response body contains no errors" do
        do_verb
        body = JSON.parse(last_response.body)
        body.should_not include('errors')
      end
    end

    context "with invalid parameters" do
      before { location_attrs["descrizione"] = '' }

      it "doesn't update location's details" do
        do_verb
        location.reload
        location.descrizione.should_not eq('')
      end

      it "fails with status == :unprocessable_entity (422)" do
        do_verb
        last_response.status.should eq(422)
      end

      it "response body contains errors" do
        do_verb
        body = JSON.parse(last_response.body)
        body.should include('errors')
      end

    end
  end

  describe 'Deleting a location' do
    it_behaves_like "requires a client"

    let(:location_attrs) { FactoryGirl.build(:location).attributes.except('id','client_id','created_at','updated_at') }
    let!(:location) { client.locations.create(location_attrs) }
    let(:delete_url) { "#{url}/#{location.id}.json" }

    def do_verb
      delete delete_url, client_id: client.id
    end

    context "when location doesn't exists" do
      it "replies with status == :not_found (404)" do
        location.id = 200
        do_verb
        last_response.status.should eq(404)
      end

      it "response body contains error_msg == 'resource not found'" do
        location.id = 200
        do_verb
        body = JSON.parse(last_response.body)
        body.should include('error_msg')
        body['error_msg'].should eq('resource not found')
      end
    end

    context "when location exists" do
      it "location gets deleted from database" do
        expect {
          do_verb
        }.to change(Location,:count).by(-1)
      end

      it "location doesn't appear among client's" do
        do_verb
        expect {
          client.locations.find(location.id)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "replies with status == :no_content (204)" do
        do_verb
        last_response.status.should eq(204)
      end
    end

  end

end
