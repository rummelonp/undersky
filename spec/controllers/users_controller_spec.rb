require 'spec_helper'

describe UsersController do

  describe "GET 'feed'" do
    it "returns http success" do
      get 'feed'
      response.should be_success
    end
  end

  describe "GET 'self'" do
    it "returns http success" do
      get 'self'
      response.should be_success
    end
  end

  describe "GET 'recent'" do
    it "returns http success" do
      get 'recent'
      response.should be_success
    end
  end

  describe "GET 'liked'" do
    it "returns http success" do
      get 'liked'
      response.should be_success
    end
  end

end
