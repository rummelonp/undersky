require 'spec_helper'

describe :routes do
  describe 'GET ""' do
    subject { {get: '/'} }
    it { should route_to(controller: 'media', action: 'popular') }
  end

  describe 'GET "authorize"' do
    subject { {get: '/authorize'} }
    it { should route_to(controller: 'authorize', action: 'authorize') }
  end

  describe 'GET "access_token"' do
    subject { {get: '/access_token'} }
    it { should route_to(controller: 'authorize', action: 'access_token') }
  end

  describe 'GET "logout"' do
    subject { {get: '/logout'} }
    it { should route_to(controller: 'authorize', action: 'logout') }
  end

  describe 'GET "users/feed"' do
    subject { {get: '/users/feed'} }
    it { should route_to(controller: 'users', action: 'feed') }
  end

  describe 'GET "users/feed/max_id/9578621"' do
    subject { {get: '/users/feed/max_id/9578621'} }
    it { should route_to(controller: 'users', action: 'feed', max_id: '9578621') }
  end

  describe 'GET "users/self"' do
    subject { {get: '/users/self'} }
    it { should route_to(controller: 'users', action: 'self') }
  end

  describe 'GET "users/982876"' do
    subject { {get: '/users/982876'} }
    it { should route_to(controller: 'users', action: 'recent', id: '982876') }
  end

  describe 'GET "users/982876/max_id/9578621"' do
    subject { {get: '/users/982876/max_id/9578621'} }
    it { should route_to(controller: 'users', action: 'recent', id: '982876', max_id: '9578621') }
  end

  describe 'GET "users/liked"' do
    subject { {get: '/users/liked'} }
    it { should route_to(controller: 'users', action: 'liked') }
  end
end
