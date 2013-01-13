# -*- coding: utf-8 -*-
require 'spec_helper'

describe LocationController do
  before do
    @client = Instagram.client

    @photo = photo_response
    @photos = [@photo] * 10
    @data = Hashie::Mash.new(data: @photos)

    @location = location_response
    @locations = [@location] * 10
  end

  describe "GET 'location'" do
    before do
      Instagram::Client.should_receive(:new).and_return(@client)
      @client.should_receive(:location_recent_media).and_return(@data)
      @client.should_receive(:location).and_return(@location)
      @client.should_receive(:location_search).and_return(@locations)
      get :recent, id: 36935
    end

    it 'should be success' do
      response.should be_success
    end
  end
end
