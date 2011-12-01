require 'spec_helper'

describe AuthorizeController do

  describe "GET 'authorize'" do
    it "returns http success" do
      get 'authorize'
      response.should be_success
    end
  end

  describe "GET 'access_token'" do
    it "returns http success" do
      get 'access_token'
      response.should be_success
    end
  end

  describe "GET 'logout'" do
    it "returns http success" do
      get 'logout'
      response.should be_success
    end
  end

end
