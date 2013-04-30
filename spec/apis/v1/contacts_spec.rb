require 'spec_helper'

describe "/api/v1/clients/:client_id/contacts", :type => :api do
  let (:client) { FactoryGirl.create(:client_with_associations) }
  let (:url) { "/api/v1/clients/#{client.id}/contacts" }

  describe "Client's contacts list" do
    include_examples "authentication required"

    def do_verb
      get url+'.json'
      @status = last_response.status
      @body = JSON.parse(last_response.body)
    end

    it "replies with status == :not_found (404) when client does not exist" do
      get "/api/v1/clients/800/contacts.json"
      last_response.status.should eq(404)
    end

    it "replies with status == :ok (200)" do
      do_verb
      @status.should eq(200)
    end

    it "fetches client's contacts list" do
      do_verb
      @body.should_not be_empty
    end
  end

  describe "Create client's contact" do
    include_examples "authentication required"
    let (:contact) { FactoryGirl.build(:contact, client: client) }

    def do_verb
      @post_params = JSON.parse(contact.to_json(except: [:id, :client_id, :created_at, :updated_at]))
      post url+".json", contact: @post_params
      @status = last_response.status
      @body = JSON.parse(last_response.body)
    end

    context "with valid parameters" do
      it "replies with status == :created (201)" do
        do_verb
        @status.should eq(201)
      end

    end
    
    context "with invalid parameters" do
      it "fails with status == :unprocessable_entity (422)" do
        contact.name = ''
        do_verb
        @status.should eq(422)
      end

      it "contains errors in body" do
        contact.name = ''
        do_verb
        @body['errors'].should_not be_empty
      end
    end
  end

  describe "Update client's contact" do
    include_examples "authentication required"
    let (:contact) { FactoryGirl.create(:contact, client: client) }

    def do_verb
      @params = JSON.parse(contact.to_json(except: [:id, :client_id, :created_at, :updated_at]))
      put url+"/#{contact.id}.json", contact: @params
      @status = last_response.status
      @body = JSON.parse(last_response.body)
    end

    context "when the contact to update doesn't exist" do
      it "fails with status == :not_found (404)" do
        contact.id = 800
        do_verb
        @status.should eq(404)
      end

      it "fails with error_msg == 'resource not found'" do
        contact.id = 800
        do_verb
        @body['error_msg'].should eq('resource not found')
      end
    end

    context "with valid parameters" do
      it "replies with status == :ok (200)" do
        contact.name = 'changed'
        do_verb
        @status.should eq(200)
      end

      it "updates contact's details" do
        contact.name = 'changed'
        do_verb
        @body['name'].should eq(contact.name)
      end
    end

    context "with invalid parameters" do
      it "replies with status == :unprocessable_entity (422)" do
        contact.name = ''
        do_verb
        @status.should eq(422)
      end

      it "doesn't change contact's details" do
        contact.name = ''
        do_verb
        contact.reload
        contact.name.should_not eq('')
      end
    end
  end

  describe "Deleting a client's contact" do
    include_examples "authentication required"
    let!(:contact) { client.contacts.first } 

    def do_verb
      delete "#{url}/#{contact.id}.json"
      @status = last_response.status
    end

    context "when contact exists" do
      it "replies with status == :no_content (204)" do
        do_verb
        @status.should eq(204)
      end

      it "deletes the contact from the database" do
        expect {
          do_verb
        }.to change(Contact, :count).by(-1)
      end

      context "assigned to an intervention" do
        before(:each) do
          i = FactoryGirl.build(:intervention_with_associations)
          i.contatto = contact.name
          i.email = contact.email
          i.locations = [client.locations.first]
          i.save
        end

        it "replies with status == :not_acceptable (406)" do
          do_verb
          @status.should eq(406)
        end

        it "error_msg == Il contatto e' stato assegnato ad almeno un RPS" do
          do_verb
          JSON.parse(last_response.body)['error_msg'].should eq("Il contatto e' stato assegnato ad almeno un RPS")
        end
      end

    end

    context "when contact does not exists" do
      it "fails with status == :not_found (404)" do
        client.id = 800
        do_verb
        @status.should eq(404)
      end

      it "fails with error_msg == 'resource not found'" do
        client.id = 800
        do_verb
        body = JSON.parse(last_response.body)
        body['error_msg'].should eq('resource not found')  
      end
    end
  end

end
