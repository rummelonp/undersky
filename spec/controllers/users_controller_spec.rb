require 'spec_helper'

describe UsersController do
  context "not authenticated" do
    describe "GET 'feed'" do
      it 'should be redirect' do
        get :feed
        response.should be_redirect
      end
    end

    describe "GET 'self'" do
      it 'should be redirect' do
        get :self
        response.should be_redirect
      end
    end

    describe "GET 'recent'" do
      it 'should be redirect' do
        get :recent, id: 982876
        response.should be_redirect
      end
    end

    describe "GET 'liked'" do
      it 'should be redirect' do
        get :liked
        response.should be_redirect
      end
    end
  end

  context "authenticated" do
    before do
      @client = Instagram.client

      @photo = photo_response
      @photos = [@photo] * 10
      @data = Hashie::Mash.new(data: @photos)

      session[:access_token] = '*** access token ***'
    end

    describe "GET 'feed'" do
      before do
        Instagram::Client.should_receive(:new).and_return(@client)
        @client.should_receive(:user_media_feed).and_return(@data)
        get :feed
      end

      it 'should be success' do
        response.should be_success
      end
    end

    describe "GET 'self'" do
      before do
        session[:user] = {id: 982876}
        get :self
      end

      it 'should be redirect' do
        response.should be_redirect
      end
    end

    describe "GET 'recent'" do
      before do
        Instagram::Client.should_receive(:new).and_return(@client)
        @client.should_receive(:user_recent_media).and_return(@photos)
        get :recent, id: 982876
      end

      it 'should be success' do
        response.should be_success
      end
    end

    describe "GET 'liked'" do
      before do
        Instagram::Client.should_receive(:new).and_return(@client)
        @client.should_receive(:user_liked_media).and_return(@data)
        get :liked
      end

      it 'should be success' do
        response.should be_success
      end
    end
  end
end
