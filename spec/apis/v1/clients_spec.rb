require 'spec_helper'

describe "/api/v1/clients.json", :type => :api do
  let(:url) { "/api/v1/clients" }
  
  describe 'Clients list' do
    let(:client) { FactoryGirl.create(:client) }

    def do_get
      get url+'.json'
      @status = last_response.status
      @body = JSON.parse(last_response.body)  
    end

    it 'fetches all the clients from the database' do
      do_get
      clients = JSON.parse(Client.all.to_json(except: [:created_at, :updated_at]))
      @body.should eq(clients)
    end

    it 'replies with status == :ok (200)' do
      do_get
      @status.should eq(200)
    end
  end

  describe 'Creating a new client' do
    let(:client) { FactoryGirl.build(:client) }

    def do_post
      @post_params =  JSON.parse(client.to_json(except: [:created_at, :updated_at]))
      post url+".json", client: @post_params
      @status = last_response.status
      @body = JSON.parse(last_response.body)
    end

    context 'with valid parameters' do
      it 'creates a client' do
        expect {
        do_post
        }.to change(Client,:count).by(1)
      end

      it 'replies with status == :created (201)' do
        do_post
        @status.should eq(201)
        @body['errors'].should be_nil
      end

      it "response body contains client's details" do
        do_post
        c = Client.find_by_ragione_sociale(client.ragione_sociale)
        @body.should eq(JSON.parse(c.to_json(except: [:created_at, :updated_at])))
      end

    end

    context 'with invalid parameters' do
      it 'fails with errors in response body'  do
        client.ragione_sociale = ''
        do_post
        @body['errors'].should_not be_nil
      end

      it 'fails with status == :unprocessable_entity (422)' do
        client.partita_iva = ''
        do_post
        @status.should eq(422)
      end
    end
  end

  describe 'Updating a client' do
    let(:client) { FactoryGirl.create(:client) }

    def do_update
      params = JSON.parse(client.to_json(except: [:created_at, :updated_at]))
      put "#{url}/#{client.id}.json", client: params
      @status = last_response.status
      @body = JSON.parse(last_response.body)
    end

    context "when the user to update doesn't exists" do
      it "fails with status == :not_found (404)" do
        client.id = 200
        do_update
        @status.should eq(404)
      end
      it "fails with error == 'resource not found'" do
        client.id = 200
        do_update
        @body['error_msg'].should eq('resource not found')
      end
    end

    context 'with valid parameters' do
      it "updates client's details" do
        client.ragione_sociale = 'updated'
        do_update
        client.reload
        client.ragione_sociale.should eq('updated')
      end

      it "replies with status == :ok (200)" do
        client.ragione_sociale = 'updated'
        do_update
        @status.should eq(200)
      end
      
      it "doesn't have any error messsages in the response" do
        client.ragione_sociale = 'updated'
        do_update
        @body['errors'].should be_nil
      end

    end

    context 'with invalid parameters' do
      it "doesn't update client's details" do
        client.ragione_sociale = ''
        do_update
        client.reload
        client.ragione_sociale.should_not eq('')
      end

      it "replies with status == :unprocessable_entity (422)" do
        client.ragione_sociale = ''
        do_update
        @status.should eq(422)  
      end

      it "has errors in the response" do
        client.ragione_sociale = ''
        do_update
        @body['errors'].should_not be_nil
      end
    end
  end

  describe 'Deleting a client' do
    let(:client) { FactoryGirl.create(:client) }

    def do_delete
      delete "#{url}/#{client.id}.json"
      @status = last_response.status
    end

    context "when the client doesn't exists" do
      before(:each) do
        client.id = 200
        do_delete
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
        do_delete
        expect {
          Client.find(client.id)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "replies with status == :no_content (204)" do
        do_delete
        @status.should eq(204)
      end
    end

  end

end
