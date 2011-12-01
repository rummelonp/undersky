require 'spec_helper'

describe AuthorizeController do

  describe 'GET "authorize"' do
    before do
      get :authorize, redirect_url: '*** redirect_url ***'
    end

    it 'should be redirect' do
      response.should be_redirect
    end

    it 'session have redirect_url' do
      session[:redirect_url].should be_present
    end
  end

  describe 'GET "access_token"' do
    context "authenticated" do
      before do
        session[:redirect_url] = '*** redirect_url ***'
        @data = Hashie::Mash.new({
          access_token: '*** access_token ***',
          user: '*** user ***'
        })
        Instagram.should_receive(:get_access_token).and_return(@data)
        get :access_token
      end

      it 'should be redirect' do
        response.should be_redirect
      end

      it 'should have access_token' do
        session[:access_token].should be_present
      end

      it 'should have user' do
        session[:user].should be_present
      end

      it 'should not have redirect_url' do
        session[:redirect_url].should be_blank
      end
    end

    context 'have error' do
      before do
        get :access_token, error: 'error'
      end

      it 'should not have access_token' do
        session[:access_token].should be_blank
      end

      it 'should not have user' do
        session[:user].should be_blank
      end
    end
  end

  describe 'GET "logout"' do
    before do
      get :logout
    end

    it 'should be redirect' do
      response.should be_redirect
    end

    it 'should not have access_token' do
      session[:access_token].should be_blank
    end

    it 'should not have user' do
      session[:user].should be_blank
    end
  end

end
