require 'spec_helper'

describe ApplicationHelper do

  describe :client do
    subject { client }
    it { should be_is_a Instagram::Client }
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

  describe :caption_text do
    subject { caption_text @photo }
    it { should == 'caption text' }
  end
end
