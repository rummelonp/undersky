require 'spec_helper'

describe ApplicationHelper do

  describe :client do
    subject { client }
    it { should be_is_a Instagram::Client }
  end
end
