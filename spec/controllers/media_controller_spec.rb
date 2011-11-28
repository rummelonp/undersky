require 'spec_helper'

describe MediaController do

  describe "GET 'popular'" do
    it "returns http success" do
      get 'popular'
      response.should be_success
    end
  end

end
