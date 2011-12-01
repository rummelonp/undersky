require 'spec_helper'

describe :routes do
  describe 'GET ""' do
    subject { {get: '/'} }
    it { should route_to(controller: 'media', action: 'popular') }
  end
end
