class RelationshipsController < ApplicationController
  before_filter :authenticate

  def follows
    id = params.delete(:id)
    @users = client.user_follows id, params.merge(count: 100)
    @user = client.user id
    unless id == session[:user][:id]
      @relationship = client.user_relationship id
    end
  end

  def followed_by
    id = params.delete(:id)
    @users = client.user_followed_by id, params.merge(count: 100)
    @user = client.user id
    unless id == session[:user][:id]
      @relationship = client.user_relationship id
    end
  end

  def follow
    id = params.delete(:id)
    data = client.follow_user id
    render json: data.to_json
  end

  def unfollow
    id = params.delete(:id)
    data = client.unfollow_user id
    render json: data.to_json
  end

end
