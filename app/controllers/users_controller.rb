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
    @data = client.user_recent_media id, params
    @photos = @data.data
    @user = client.user id
    unless id == session[:user][:id]
      @relationship = client.user_relationship id
    end
  end

  def liked
    @data = client.user_liked_media params
    @photos = @data.data
    @user = client.user
  end

end
