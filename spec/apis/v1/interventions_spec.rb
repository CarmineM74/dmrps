require 'spec_helper'

shared_examples_for "requires a client" do
  it "fails with status == :not_found if client_id can't be found" do
    client.id = 200
    do_verb
    last_response.status.should eq(404)
  end

end

describe "/api/v1/interventions.json", :type => :api do

  let(:client) { FactoryGirl.create(:client) }
  let(:user) { FactoryGirl.create(:user) }
  let(:url) { "/api/v1/interventions" }

  before(:each) do
    @query = ''
  end

  describe "Interventions index" do
    include_examples "authentication required"
    def do_verb
      get url+".json",query: @query
      @body = JSON.parse(last_response.body)
      @status = last_response.status
    end

    describe "Fetch all interventions for a given client" do
      it "return an empty array where there are no interventions" do
        do_verb
        @body.should eq([])
      end

      it "returns an array with client's interventions" do
        intervention = FactoryGirl.create(:intervention)
        do_verb
        @body.should_not be_empty
        i = @body.first
        i['user'].should_not be_empty
        i['client'].should_not be_empty
        i['location'].should_not be_empty
      end
    end

    describe "When a filter is specified" do
      let (:i1) { FactoryGirl.create(:intervention, user: FactoryGirl.create(:user)) }
      let (:i2) { FactoryGirl.create(:intervention, user: FactoryGirl.create(:user)) }
      let (:i3) { FactoryGirl.create(:intervention, user: FactoryGirl.create(:user)) }

      it "fetches an intervention with id like" do
        @query = i2.id
        do_verb
        @body.first['id'].should eq(@query)
      end

      it "fetches an intervention with user email like" do
        @query = i3.user.email
        do_verb
        @body.first['user']['email'].should eq(i3.user.email)
      end

      it "fetches an intervention with client ragione_sociale like" do
        @query = i1.client.ragione_sociale
        do_verb
        @body.first['client']['ragione_sociale'].should eq(@query)
      end
    end
  end

  describe "Creating an intervention" do
    include_examples "authentication required"
    let(:intervention) { FactoryGirl.build(:intervention, user: FactoryGirl.create(:user)) }

    before(:each) do
      @post_params = JSON.parse(intervention.to_json(except:[:id, :created_at, :updated_at]))
    end

    def do_verb
      post "#{url}.json",intervention: @post_params
    end

    describe "when successful" do
      it "replies with status == :created (201)" do
        @post_params['location_ids'] = intervention.location_ids
        do_verb
        last_response.status.should eq(201)
      end
    end

    describe "when unsuccessful" do
      it "replies with status == :unprocessable_entity (422)" do
        do_verb
        last_response.status.should eq(422)
      end

      it "has errors" do
        do_verb
        body = JSON.parse(last_response.body)
        body['errors'].should_not be_empty
      end
    end

    describe "fails when" do
      it "has unexisting user associated" do
        @post_params['location_ids'] = intervention.location_ids
        @post_params['user_id'] = 800
        do_verb
        last_response.status.should eq(422)
      end

      # 2012.10.14
      # Diversamente da quanto accade nel test precedente, il server non
      # restituisce lo status 422 ma il 404 perche' viene intercettata
      # l'eccezione ActiveRecord::RecordNotFound dall'ApplicationController.
      # Mi aspettavo che lo stesso comportamento avvenisse nel test precedente.
      # *** DA INDAGARE ***
      it "has unexisting locations associated" do
        @post_params['location_ids'] = [100]
        do_verb
        last_response.status.should eq(404)
      end

    end

  end

  describe "Fetching a single intervention" do
    include_examples "authentication required"

    let(:intervention) { FactoryGirl.create(:intervention, user: FactoryGirl.create(:user)) }
    let(:show_url) { "#{url}/#{intervention.id}.json" }
    
    def do_verb
      get show_url
    end

    context "when intervention can't be found" do
      it "fails with status == :not_found (404)" do
        intervention.id = 800
        do_verb
        last_response.status.should eq(404)
      end
    end

    context "when intervention can be found" do
      it "succeeds with status == :ok (200)" do
        do_verb
        last_response.status.should eq(200)
      end

      it "replies with intervention's details" do
        do_verb
        body = JSON.parse(last_response.body)
        body['location'].should_not be_empty
        body['user'].should_not be_empty
        body['client'].should_not be_empty
      end
    end

  end

  describe "Updating an intervention" do
    include_examples "authentication required"
    let(:intervention) { FactoryGirl.create(:intervention, user: FactoryGirl.create(:user)) }
    let(:put_url) { "#{url}/#{intervention.id}.json" } 

    before(:each) do
      @put_params = JSON.parse(intervention.to_json(except:[:created_at, :updated_at]))
    end

    def do_verb
      put put_url,intervention: @put_params
    end

    it "fails when the resource cannot be located" do
      intervention.id = 800
      do_verb
      last_response.status.should eq(404)
    end

    it "replies with status == :ok when update succeed" do
      @put_params['note'] = "updated!"
      do_verb
      last_response.status.should eq(200)
    end

    it "replies with status == :unprocessable_entity (422) when update fails due to validations" do
      @put_params['user_id'] = nil
      do_verb
      last_response.status.should eq(422)
    end

    it "has errors when fails due to validations" do
      @put_params['user_id'] = nil
      do_verb
      body = JSON.parse(last_response.body)
      body['errors'].should_not be_empty
    end

  end

  describe "Deleting an intervention" do
    include_examples "authentication required"

    let!(:intervention) { FactoryGirl.create(:intervention, user: FactoryGirl.create(:user)) }
    let(:delete_url) { "#{url}/#{intervention.id}.json" } 

    def do_verb
      delete delete_url
    end

    it "it fails when intervention can't be found" do
      intervention.id = 800
      do_verb
      last_response.status.should eq(404)
    end

    it "replies with error_msg = 'resource not found' when intervention can't be found" do
      intervention.id = 800
      do_verb
      body = JSON.parse(last_response.body)
      body["error_msg"].should eq('resource not found')
    end

    it "deletes intervention from the database when successful" do
      expect {
        do_verb
      }.to change(Intervention,:count).by(-1)
    end

    it "replies with status == :no_content (204) when delete is successful" do
      do_verb
      last_response.status.should eq(204)
    end

  end

end
