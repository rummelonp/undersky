require 'spec_helper'

describe Time do
  describe :to_pretty do
    before do
      @now = Time.now
      Time.stub!(:now).and_return(@now)
    end

    it 'should == "just now"' do
      @now.to_pretty.should == 'just now'
    end

    it 'should == "1s"' do
      1.second.ago(@now).to_pretty.should == '1s'
    end

    it 'should == "1m"' do
      1.minute.ago(@now).to_pretty.should == '1m'
    end

    it 'should == "1h"' do
      1.hour.ago(@now).to_pretty.should == '1h'
    end

    it 'should == "1d"' do
      1.day.ago(@now).to_pretty.should == '1d'
    end

    it 'should == "1w"' do
      1.week.ago(@now).to_pretty.should == '1w'
    end
  end
end
