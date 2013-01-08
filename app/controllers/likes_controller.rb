class LikesController < ApplicationController
  before_filter :authenticate

  def likes
    @likes = client.media_likes params[:id]
    respond_to do |format|
      format.json { render json: @likes.to_json }
      format.html { render layout: false }
    end
  end

  def like
    client.like_media params[:id]
    @like = session[:user]
    respond_to do |format|
      format.json { render json: @like.to_json }
      format.html { render layout: false }
    end
  end

  def unlike
    client.unlike_media params[:id]
    render text: ''
  end

end
