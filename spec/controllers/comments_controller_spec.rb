require 'spec_helper'

describe CommentsController do
  context "not authenticated" do
    describe "GET 'comments'" do
      it 'should be status 403' do
        xhr :get, :comments, id: 9578621
        response.status == 403
      end
    end

    describe "POST 'comments'" do
      it 'should be status 403' do
        xhr :post, :create_comment, id: 9578621, text: 'comment'
        response.status == 403
      end
    end

    describe "DELETE 'comments'" do
      it 'should be status 403' do
        xhr :delete, :delete_comment, id: 9578621, comment_id: '9578621'
        response.status == 403
      end
    end
  end

  context "authenticated" do
    before do
      @client = Instagram.client

      @comment = comment_response
      @comments = [@comment] * 10

      session[:access_token] = '*** access token ***'
    end

    describe "GET 'comments'" do
      before do
        Instagram::Client.should_receive(:new).and_return(@client)
        @client.should_receive(:media_comments).and_return(@users)
        xhr :get, :comments, id: 9578621
      end

      it "should be success" do
        response.should be_success
      end
    end

    describe "POST 'create_comment'" do
      before do
        Instagram::Client.should_receive(:new).and_return(@client)
        @client.should_receive(:create_media_comment)
        xhr :post, :create_comment, id: 9578621
      end

      it "should be success" do
        response.should be_success
      end
    end

    describe "GET 'delete_comment'" do
      it "returns http success" do
        pending "to be implement after"
      end
    end
  end
end
