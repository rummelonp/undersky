require 'spec_helper'

describe :routes do
  describe 'GET ""' do
    subject { {get: '/'} }
    it { should route_to(controller: 'media', action: 'popular') }
  end

  describe 'GET "about"' do
    subject { {get: '/about'} }
    it { should route_to(controller: 'about', action: 'index') }
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

  describe 'GET "search"' do
    subject { {get: '/search'} }
    it { should route_to(controller: 'search', action: 'search') }
  end

  describe 'GET "search/query"' do
    subject { {get: '/search/query'} }
    it { should route_to(controller: 'search', action: 'search', name: 'query') }
  end

  describe 'GET "tags/query"' do
    subject { {get: '/tags/query'} }
    it { should route_to(controller: 'tags', action: 'recent', name: 'query') }
  end

  describe 'GET "tags/query/max_id/9578621"' do
    subject { {get: '/tags/query/max_id/9578621'} }
    it { should route_to(controller: 'tags', action: 'recent', name: 'query', max_id: '9578621') }
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

  describe 'GET "users/mitukiii"' do
    subject { {get: '/users/mitukiii'} }
    it { should route_to(controller: 'users', action: 'recent', id: 'mitukiii') }
  end

  describe 'GET "users/mitukiii/max_id/9578621"' do
    subject { {get: '/users/mitukiii/max_id/9578621'} }
    it { should route_to(controller: 'users', action: 'recent', id: 'mitukiii', max_id: '9578621') }
  end

  describe 'GET "users/liked"' do
    subject { {get: '/users/liked'} }
    it { should route_to(controller: 'users', action: 'liked') }
  end

  describe 'GET "users/mitukiii/follows"' do
    subject { {get: '/users/mitukiii/follows'} }
    it { should route_to(controller: 'relationships', action: 'follows', id: 'mitukiii') }
  end

  describe 'GET "users/mitukiii/follows/cursor/9495024"' do
    subject { {get: '/users/mitukiii/follows/cursor/9495024'} }
    it { should route_to(controller: 'relationships', action: 'follows', id: 'mitukiii', cursor: '9495024') }
  end

  describe 'GET "users/mitukiii/followed_by"' do
    subject { {get: '/users/mitukiii/followed_by'} }
    it { should route_to(controller: 'relationships', action: 'followed_by', id: 'mitukiii') }
  end

  describe 'GET "users/mitukiii/followed_by/cursor/9495024"' do
    subject { {get: '/users/mitukiii/followed_by/cursor/9495024'} }
    it { should route_to(controller: 'relationships', action: 'followed_by', id: 'mitukiii', cursor: '9495024') }
  end

  describe 'POST "users/mitukiii/follow"' do
    subject { {post: '/users/mitukiii/follow'} }
    it { should route_to(controller: 'relationships', action: 'follow', id: 'mitukiii') }
  end

  describe 'DELETE "users/mitukiii/follow"' do
    subject { {delete: '/users/mitukiii/follow'} }
    it { should route_to(controller: 'relationships', action: 'unfollow', id: 'mitukiii') }
  end

  describe 'GET "media/9578621/likes"' do
    subject { {get: 'media/9578621/likes'} }
    it { should route_to(controller: 'likes', action: 'likes', id: '9578621') }
  end

  describe 'POST "media/9578621/likes"' do
    subject { {post: 'media/9578621/likes'} }
    it { should route_to(controller: 'likes', action: 'like', id: '9578621') }
  end

  describe 'DELETE "media/9578621/likes"' do
    subject { {delete: 'media/9578621/likes'} }
    it { should route_to(controller: 'likes', action: 'unlike', id: '9578621') }
  end

  describe 'GET "media/9578621/comments"' do
    subject { {get: 'media/9578621/comments'} }
    it { should route_to(controller: 'comments', action: 'comments', id: '9578621') }
  end

  describe 'POST "media/9578621/comments"' do
    subject { {post: 'media/9578621/comments'} }
    it { should route_to(controller: 'comments', action: 'create_comment', id: '9578621') }
  end

  describe 'DELETE "media/9578621/comments/9578621"' do
    subject { {delete: 'media/9578621/comments/9578621'} }
    it { should route_to(controller: 'comments', action: 'delete_comment', id: '9578621', comment_id: '9578621') }
  end

  describe 'GET "test"' do
    subject { {get: 'test'} }
    it { should route_to(controller: 'error', action: 'not_found', a: 'test') }
  end
end
