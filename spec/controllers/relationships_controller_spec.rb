require 'spec_helper'

describe RelationshipsController do
  context "not authenticated" do
    describe "GET 'follows'" do
      it "should be redirect" do
        get :follows, id: 982876
        response.should be_redirect
      end
    end

    describe "GET 'followed_by'" do
      it "should be redirect" do
        get :followed_by, id: 982876
        response.should be_redirect
      end
    end

    describe "POST 'follow'" do
      it "should be redirect" do
        xhr :post, :follow, id: 982876
        response.should be_redirect
      end
    end

    describe "DELETE 'follow'" do
      it "should be redirect" do
        xhr :delete, :unfollow, id: 982876
        response.should be_redirect
      end
    end
  end

  context "authenticated" do
    before do
      @client = Instagram.client

      @user = user_response
      @users = [@user] * 100

      @relationship = relationship_response

      session[:user] = {id: 9578621}
      session[:access_token] = '*** access token ***'
    end

    describe "GET 'follows'" do
      before do
        Instagram::Client.should_receive(:new).and_return(@client)
        @client.should_receive(:user_follows).and_return(@users)
        @client.should_receive(:user).and_return(@user)
        @client.should_receive(:user_relationship).and_return(@relationship)
        get :follows, id: 982876
      end

      it "should be success" do
        response.should be_success
      end
    end

    describe "GET 'followed_by'" do
      before do
        Instagram::Client.should_receive(:new).and_return(@client)
        @client.should_receive(:user_followed_by).and_return(@users)
        @client.should_receive(:user).and_return(@user)
        @client.should_receive(:user_relationship).and_return(@relationship)
        get :followed_by, id: 982876
      end

      it "should be success" do
        response.should be_success
      end
    end

    describe "POST 'follow'" do
      before do
        Instagram::Client.should_receive(:new).and_return(@client)
        @client.should_receive(:follow_user).and_return(@relationship)
        xhr :post, :follow, id: 982876
      end

      it "should be success" do
        response.should be_success
      end
    end

    describe "DELETE 'follow'" do
      before do
        Instagram::Client.should_receive(:new).and_return(@client)
        @client.should_receive(:unfollow_user).and_return(@relationship)
        xhr :delete, :unfollow, id: 982876
      end

      it "should be success" do
        response.should be_success
      end
    end
  end
end
