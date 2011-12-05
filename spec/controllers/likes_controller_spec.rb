require 'spec_helper'

describe LikesController do
  context "not authenticated" do
    describe "GET 'likes'" do
      it 'should be status 403' do
        xhr :get, :likes, id: 9578621
        response.status == 403
      end
    end

    describe "POST 'likes'" do
      it 'should be status 403' do
        xhr :post, :like, id: 9578621
        response.status == 403
      end
    end

    describe "DELETE 'likes'" do
      it 'should be status 403' do
        xhr :delete, :unlike, id: 9578621
        response.status == 403
      end
    end
  end

  context "authenticated" do
    before do
      @client = Instagram.client

      @user = user_response
      @users = [@user] * 10

      session[:access_token] = '*** access token ***'
    end

    describe "GET 'likes'" do
      before do
        Instagram::Client.should_receive(:new).and_return(@client)
        @client.should_receive(:media_likes).and_return(@users)
        xhr :get, :likes, id: 9578621
      end

      it "should be success" do
        response.should be_success
      end
    end

    describe "POST 'like'" do
      before do
        Instagram::Client.should_receive(:new).and_return(@client)
        @client.should_receive(:like_media)
        xhr :post, :like, id: 9578621
      end

      it "should be success" do
        response.should be_success
      end
    end

    describe "GET 'unlike'" do
      before do
        Instagram::Client.should_receive(:new).and_return(@client)
        @client.should_receive(:unlike_media)
        xhr :delete, :unlike, id: 9578621
      end

      it "should be success" do
        response.should be_success
      end
    end
  end
end
