require 'spec_helper'

describe "/api/v1/activities", :type => :api do
  let!(:url) {"/api/v1/activities"}
  
  describe "Activities index" do
    include_examples "authentication required"

    let!(:activity) { FactoryGirl.create(:activity) }

    def do_verb
      get url+".json"
      @status = last_response.status
      @body = JSON.parse(last_response.body)
    end

    it "replies with status == :ok" do
      do_verb
      @status.should eq(200)
    end

    it "fetches activities from database" do
      do_verb
      @body.should_not be_empty
    end
  end

  describe "Create Activity" do
    include_examples "authentication required"
    let(:activity) { FactoryGirl.build(:activity) }

    def do_verb
      @params = JSON.parse(activity.to_json(except: [:id, :created_at, :updated_at]))
      post url+".json", activity: @params
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
      it "replies with status == :unprocessable_entity (422)" do
        activity.descrizione = ''
        do_verb
        @status.should eq(422)
      end
    end
  end

  describe "Update activity" do
    include_examples "authentication required"
    let(:activity) { FactoryGirl.create(:activity) }

    def do_verb
      @params = JSON.parse(activity.to_json(except: [:created_at, :updated_at]))
      put "#{url}/#{activity.id}.json", activity: @params
      @status = last_response.status
      @body = JSON.parse(last_response.body)
    end  

    context "when activity does not exists" do
      it "replies with status == :not_found (404)" do
        activity.id = 800
        do_verb
        @status.should eq(404)
      end

      it "replies with error == 'resource not found'" do
        activity.id = 800
        do_verb
        @body['error_msg'].should eq('resource not found')
      end
    end

    context "with valid parameters" do
      it "replies with status == :ok (200)" do
        activity.descrizione = 'changed'
        do_verb
        @status.should eq(200)
      end

      it "updates activity's details" do
        activity.descrizione = 'changed'
        do_verb
        activity.reload
        activity.descrizione.should eq('changed')
      end
    end

    context "with invalid parameters" do
      it "replies with status == :unprocessable_entity (422)" do
        activity.descrizione = ''
        do_verb
        @status.should eq(422)
      end

      it "does not update acitivity's details" do
        activity.descrizione = ''
        do_verb
        activity.reload
        activity.descrizione.should_not eq('')
      end
    end

  end

end

