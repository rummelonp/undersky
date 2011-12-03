require 'spec_helper'

describe CommentsController do
  context "not authenticated" do
    describe "GET 'comments'" do
      it 'should be redirect' do
        xhr :get, :comments, id: 9578621
        response.should be_redirect
      end
    end

    describe "POST 'comments'" do
      it 'should be redirect' do
        xhr :post, :create_comment, id: 9578621, text: 'comment'
        response.should be_redirect
      end
    end

    describe "DELETE 'comments'" do
      it 'should be redirect' do
        xhr :delete, :delete_comment, id: 9578621
        response.should be_redirect
      end
    end
  end

  context "authenticated" do
    describe "GET 'comments'" do
      it "returns http success" do
        pending "to be implement after"
      end
    end

    describe "GET 'create_comment'" do
      it "returns http success" do
        pending "to be implement after"
      end
    end

    describe "GET 'delete_comment'" do
      it "returns http success" do
        pending "to be implement after"
      end
    end
  end
end
