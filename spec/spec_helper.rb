# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

module SpecHelper
  def user_response
    @user_response ||= Hashie::Mash.new({
      id: '1',
      profile_picture: 'http://example.com/profile_picture.jpg',
      full_name: 'test user',
      username: 'test user',
      bii: 'bio bio bio bio bio',
      website: 'http://example.com/',
      counts: {
        media: 1,
        follows: 1,
        followed_by: 1
      }
    })
  end

  def photo_response
    @photo_response ||= Hashie::Mash.new({
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
  end

  def comment_response
    @comment_response ||= Hashie::Mash.new({
      id: '1',
      text: 'comment',
      from: {
        id: '1',
        profile_picture: 'http://example.com/profile_picture.jpg',
        full_name: 'test user',
        username: 'test user'
      }
    })
  end

  def relationship_response
    @relationship_response ||= Hashie::Mash.new({
      outgoing_status: 'none',
      incoming_status: 'none'
    })
  end

  def tag_response
    @tag_response ||= Hashie::Mash.new({
      name: 'tag',
      media_count: 1
    })
  end
end

RSpec.configure do |config|
  config.include(SpecHelper)

  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
end
