require 'spec_helper'

describe ApplicationHelper do

  describe :client do
    subject { client }
    it { should be_is_a Instagram::Client }
  end

  describe :authenticated? do
    context 'session have access token' do
      before do
        session[:access_token] = '*** access_token ***'
      end

      it 'should be true' do
        authenticated?.should be_true
      end
    end

    context 'session not have access token' do
      before do
        session[:access_token] = nil
      end

      it 'should be false' do
        authenticated?.should be_false
      end
    end
  end

  before do
    @photo = Hashie::Mash.new({
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
    })
  end

  describe :photo_tag do
    context :low_resolution do
      subject { photo_tag @photo, :low_resolution }
      it { should == '<img alt="caption text" height="306" src="http://example.com/low_resolution.jpg" width="306" />' }
    end
    context :thumbnail do
      subject { photo_tag @photo, :thumbnail }
      it { should == '<img alt="caption text" height="150" src="http://example.com/thumbnail.jpg" width="150" />' }
    end
    context :standard_resolution do
      subject { photo_tag @photo, :standard_resolution }
      it { should == '<img alt="caption text" height="612" src="http://example.com/standard_resolution.jpg" width="612" />' }
    end
  end

  describe :link_to_external do
    subject { link_to_external 'Example', 'http://example.com/' }
    it { should == '<a href="http://example.com/" rel="external nofollow" target="_blank">Example</a>' }
  end

  describe :nav_link_tag do
    before do
      @request = ActionController::TestRequest.new
      @request.stub!(:url).and_return('http://example.com/')
      @request.stub!(:fullpath).and_return('')
      self.stub!(:request).and_return(@request)
    end

    context 'current page' do
      subject { nav_link_tag 'Example', 'http://example.com/' }
      it { should == '<li class="active"><a href="http://example.com/">Example</a></li>' }
    end

    context 'not current page' do
      subject { nav_link_tag 'Example', 'http://example.com/other' }
      it { should == '<li><a href="http://example.com/other">Example</a></li>' }
    end
  end

  describe :caption_text do
    subject { caption_text @photo }
    it { should == 'caption text' }
  end

  describe :pretty_time do
    before do
      Time.stub!(:now).and_return(0)
    end

    it 'should == "just now"' do
      photo = Hashie::Mash.new(created_time: 0)
      pretty_time(photo).should == 'just now'
    end

    it 'should == "1s"' do
      photo = Hashie::Mash.new(created_time: -1)
      pretty_time(photo).should == '1s'
    end

    it 'should == "1m"' do
      photo = Hashie::Mash.new(created_time: - 60)
      pretty_time(photo).should == '1m'
    end

    it 'should == "1h"' do
      photo = Hashie::Mash.new(created_time: - 60 * 60)
      pretty_time(photo).should == '1h'
    end

    it 'should == "1d"' do
      photo = Hashie::Mash.new(created_time: - 60 * 60 * 24)
      pretty_time(photo).should == '1d'
    end

    it 'should == "1w"' do
      photo = Hashie::Mash.new(created_time: - 60 * 60 * 24 * 7)
      pretty_time(photo).should == '1w'
    end
  end
end
