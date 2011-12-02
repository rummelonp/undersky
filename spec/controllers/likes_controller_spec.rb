require 'spec_helper'

describe LikesController do

  describe "GET 'likes'" do
    it "returns http success" do
      get 'likes'
      response.should be_success
    end
  end

  describe "GET 'like'" do
    it "returns http success" do
      get 'like'
      response.should be_success
    end
  end

  describe "GET 'unlike'" do
    it "returns http success" do
      get 'unlike'
      response.should be_success
    end
  end

end
