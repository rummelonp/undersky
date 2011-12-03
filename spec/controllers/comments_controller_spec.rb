require 'spec_helper'

describe CommentsController do

  describe "GET 'comments'" do
    it "returns http success" do
      get 'comments'
      response.should be_success
    end
  end

  describe "GET 'create_comment'" do
    it "returns http success" do
      get 'create_comment'
      response.should be_success
    end
  end

  describe "GET 'delete_comment'" do
    it "returns http success" do
      get 'delete_comment'
      response.should be_success
    end
  end

end
