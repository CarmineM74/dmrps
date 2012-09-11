require 'spec_helper'

describe "/api/v1/clients.json", :type => :api do
  let(:url) { "/api/v1/clients" }
  
  describe 'Clients list' do
    it 'fetches all the clients from the database'
    it 'replies with status == :ok (200)'
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
    end
  end

  describe 'Updating a client' do
    context 'with valid parameters' do
    end
    context 'with invalid parameters' do
    end
  end

  describe 'Deleting a client' do
  end

end
