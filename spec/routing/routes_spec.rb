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
end
