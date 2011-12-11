class RelationshipsController < ApplicationController
  before_filter :authenticate

  def follows
    id = params.delete(:id)
    response = client.user_follows id, params.merge(count: 100)
    @users = response.data
    @pagination = response.pagination
    @user = client.user id
    unless mine? id
      @relationship = client.user_relationship id
    end
  end

  def followed_by
    id = params.delete(:id)
    response = client.user_followed_by id, params.merge(count: 100)
    @users = response.data
    @pagination = response.pagination
    @user = client.user id
    unless mine? id
      @relationship = client.user_relationship id
    end
  end

  def follow
    id = params.delete(:id)
    response = client.follow_user id
    render json: response.to_json
  end

  def unfollow
    id = params.delete(:id)
    response = client.unfollow_user id
    render json: response.to_json
  end

end
