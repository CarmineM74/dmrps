require 'spec_helper'

describe "/api/v1/clients.json", :type => :api do
  let(:url) { "/api/v1/clients" }
  
  describe 'Clients list' do
    include_examples "authentication required"

    let(:client) { FactoryGirl.create(:client) }

    def do_verb
      get url+'.json'
      @status = last_response.status
      @body = JSON.parse(last_response.body)  
    end

    it 'fetches all the clients from the database' do
      do_verb
      clients = JSON.parse(Client.all.to_json(except: [:created_at, :updated_at]))
      @body.should eq(clients)
    end

    it 'replies with status == :ok (200)' do
      do_verb
      @status.should eq(200)
    end
  end

  describe 'Fetching a single client' do
    include_examples "authentication required"

    let(:client) { FactoryGirl.create(:client) }
    let(:show_url) { "#{url}/#{client.id}.json" }

    def do_verb
      get show_url
    end

    context "when client can't be found" do
      it "fails with status == :not_found (404)" do
        client.id = 800
        do_verb
        last_response.status.should eq(404)
      end
    end

    context "when client is found" do
      it "succeeds with status == :ok (200)" do
        do_verb
        last_response.status.should eq(200)
      end

      it "replies with client's details" do
        do_verb
        body = JSON.parse(last_response.body)
        body.should_not be_empty
      end
    end

  end

  describe 'Creating a new client' do
    include_examples "authentication required"

    let(:client_attrs) { FactoryGirl.attributes_for(:client) }

    def do_verb
      post url+".json", client: client_attrs
      @status = last_response.status
      @body = JSON.parse(last_response.body)
    end

    context 'with valid parameters' do
      it 'creates a client' do
        expect {
        do_verb
        }.to change(Client,:count).by(1)
      end

      it 'replies with status == :created (201)' do
        do_verb
        @status.should eq(201)
        @body['errors'].should be_nil
      end

    end

    context 'with invalid parameters' do
      it 'fails with errors in response body'  do
        client_attrs[:ragione_sociale] = ''
        do_verb
        @body['errors'].should_not be_nil
      end

      it 'fails with status == :unprocessable_entity (422)' do
        client_attrs[:ragione_sociale] = ''
        do_verb
        @status.should eq(422)
      end
    end
  end

  describe 'Updating a client' do
    include_examples "authentication required"

    let(:client) { FactoryGirl.create(:client) }

    def do_verb
      params = JSON.parse(client.to_json(except: [:created_at, :updated_at]))
      put "#{url}/#{client.id}.json", client: params
      @status = last_response.status
      @body = JSON.parse(last_response.body)
    end

    context "when the user to update doesn't exists" do
      it "fails with status == :not_found (404)" do
        client.id = 200
        do_verb
        @status.should eq(404)
      end
      it "fails with error == 'resource not found'" do
        client.id = 200
        do_verb
        @body['error_msg'].should eq('resource not found')
      end
    end

    context 'with valid parameters' do
      it "updates client's details" do
        client.ragione_sociale = 'updated'
        do_verb
        client.reload
        client.ragione_sociale.should eq('updated')
      end

      it "replies with status == :ok (200)" do
        client.ragione_sociale = 'updated'
        do_verb
        @status.should eq(200)
      end
      
      it "doesn't have any error messsages in the response" do
        client.ragione_sociale = 'updated'
        do_verb
        @body['errors'].should be_nil
      end

    end

    context 'with invalid parameters' do
      it "doesn't update client's details" do
        client.ragione_sociale = ''
        do_verb
        client.reload
        client.ragione_sociale.should_not eq('')
      end

      it "replies with status == :unprocessable_entity (422)" do
        client.ragione_sociale = ''
        do_verb
        @status.should eq(422)  
      end

      it "has errors in the response" do
        client.ragione_sociale = ''
        do_verb
        @body['errors'].should_not be_nil
      end
    end
  end

  describe 'Deleting a client' do
    include_examples "authentication required"

    let(:client) { FactoryGirl.create(:client) }

    def do_verb
      delete "#{url}/#{client.id}.json"
      @status = last_response.status
    end

    context "when the client doesn't exists" do
      before(:each) do
        client.id = 200
        do_verb
      end

      it "fails with status == :not_found (404)" do
        @status.should eq(404)
      end

      it "fails with error_msg == 'resource not found'" do
        last_response.body.should include('resource not found')
      end
    end

    context "when requested client exists" do
      it "deletes the client from the database" do
        do_verb
        expect {
          Client.find(client.id)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "replies with status == :no_content (204)" do
        do_verb
        @status.should eq(204)
      end

      it "deletes associated locations"

      it "deletes associated contacts"

      context "with interventions" do
        it "replies with status == :not_acceptable (406)"
        it "error_msg == Ci sono degli RPS associati al cliente"
      end

    end

  end

end
