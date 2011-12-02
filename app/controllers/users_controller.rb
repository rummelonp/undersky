class UsersController < ApplicationController
  before_filter :authenticate

  def feed
    @data = client.user_media_feed params
    @photos = @data.data
    @user = client.user
  end

  def self
    redirect_to recent_url(id: session[:user][:id])
  end

  def recent
    id = params.delete :id
    @photos = client.user_recent_media id, params
    @user = client.user id
  end

  def liked
    @data = client.user_liked_media params
    @photos = @data.data
    @user = client.user
  end

end
