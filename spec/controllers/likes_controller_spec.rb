require 'spec_helper'

describe LikesController do
  context "not authenticated" do
    describe "GET 'likes'" do
      it 'should be redirect' do
        xhr :get, :likes, id: 9578621
        response.should be_redirect
      end
    end

    describe "POST 'likes'" do
      it 'should be redirect' do
        xhr :post, :like, id: 9578621
        response.should be_redirect
      end
    end

    describe "DELETE 'likes'" do
      it 'should be redirect' do
        xhr :delete, :unlike, id: 9578621
        response.should be_redirect
      end
    end
  end

  describe "GET 'likes'" do
    it "returns http success" do
      pending "to be implement after"
    end
  end

  describe "GET 'like'" do
    it "returns http success" do
      pending "to be implement after"
    end
  end

  describe "GET 'unlike'" do
    it "returns http success" do
      pending "to be implement after"
    end
  end

end
