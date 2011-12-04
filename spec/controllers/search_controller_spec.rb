require 'spec_helper'

describe SearchController do

  describe "GET 'search'" do
    context "not have query" do
      it "should be success" do
        get :search
        response.should be_success
      end
    end

    context "have query" do
      before do
        @client = Instagram.client

        @user = user_response
        @users = [@user] * 10

        @tag = tag_response
        @tags = [@tag] * 10

        Instagram::Client.should_receive(:new).and_return(@client)
        @client.should_receive(:user_search).and_return(@users)
        @client.should_receive(:tag_search).and_return(@tags)

        get :search, name: 'query'
      end

      it "should be success" do
        response.should be_success
      end
    end
  end
end
