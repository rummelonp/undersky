require 'spec_helper'

describe RelationshipsController do

  describe "GET 'follows'" do
    it "returns http success" do
      get 'follows'
      response.should be_success
    end
  end

  describe "GET 'followed_by'" do
    it "returns http success" do
      get 'followed_by'
      response.should be_success
    end
  end

end
