require 'spec_helper'

describe TagsController do

  describe "GET 'recent'" do
    before do
      @client = Instagram.client
      @tag = tag_response
      @photo = photo_response
      @photos = [@photo] * 10
      @data = Hashie::Mash.new(data: @photos)
      Instagram::Client.should_receive(:new).and_return(@client)
      @client.should_receive(:tag_recent_media).and_return(@data)
      @client.should_receive(:tag).and_return(@tag)
      get :recent, name: 'query'
    end

    it "should be success" do
      response.should be_success
    end
  end

end
