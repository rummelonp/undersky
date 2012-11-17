class UsersController < ApplicationController
  before_filter :authenticate

  def feed
    response = client.user_media_feed params
    @photos = response.data
    @pagination = response.pagination
    @user = client.user
  end

  def self
    redirect_to recent_url(id: session[:user][:id])
  end

  def recent
    id = params.delete :id
    response = client.user_recent_media id, params
    @photos = response.data
    @pagination = response.pagination
    @user = client.user id
    unless mine? id
      @relationship = client.user_relationship id
    end
  end

  def liked
    response = client.user_liked_media params
    @photos = response.data
    @pagination = response.pagination
    @user = client.user
  end

end
