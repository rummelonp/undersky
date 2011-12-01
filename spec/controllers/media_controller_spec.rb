# -*- coding: utf-8 -*-
require 'spec_helper'

describe MediaController do
  before do
    @client = Instagram.client

    @photo = photo_response
    @photos = [@photo] * 10
  end

  describe "GET 'popular'" do
    before do
      Instagram::Client.should_receive(:new).and_return(@client)
      @client.should_receive(:media_popular).and_return(@photos)
      get :popular
    end

    it 'should be success' do
      response.should be_success
    end
  end

end
