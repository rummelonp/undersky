require 'spec_helper'

describe RelationshipsController do
  context "not authenticated" do
    describe "GET 'follows'" do
      it "should be redirect" do
        get :follows, id: 982876
        response.should be_redirect
      end
    end

    describe "GET 'followed_by'" do
      it "should be redirect" do
        get :followed_by, id: 982876
        response.should be_redirect
      end
    end
  end
end
