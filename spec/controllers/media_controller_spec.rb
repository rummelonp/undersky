# -*- coding: utf-8 -*-
require 'spec_helper'

describe MediaController do
  before do
    @client = Instagram.client

    @photo = Hashie::Mash.new({
      tags: [],
      location: nil,
      comments: {
        count: 0,
        data: []
      },
      filter: 'filter',
      created_time: '1298678400',
      link: 'http://example.com/link.html',
      likes: {
        count: 0,
        data: []
      },
      images: {
        low_resolution: {
          url: 'http://example.com/low_resolution.jpg',
          width: 306,
          height: 306
        },
        thumbnail: {
          url: 'http://example.com/thumbnail.jpg',
          width: 150,
          height: 150
        },
        standard_resolution: {
          url: 'http://example.com/standard_resolution.jpg',
          width: 612,
          height: 612
        }
      },
      caption: {
        text: 'caption text'
      },
      created_time: '1298678400',
      caption: {
        created_time: '1298678400',
        text: 'caption text',
        from: {
          username: 'test user',
          profile_picture: 'http://example.com/profile_picture.jpg',
          id: '1',
          full_name: 'test user'},
        id: '1'
      },
      type: 'image',
      id: '1',
      user: {
        username: 'test user',
        profile_picture: 'http://example.com/profile_picture.jpg',
        id: '1',
        full_name: 'test user'
      }
    })

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
