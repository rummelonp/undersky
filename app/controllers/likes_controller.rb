class LikesController < ApplicationController
  before_filter :authenticate

  def likes
    data = client.media_likes params[:id]
    render json: data.to_json
  end

  def like
    client.like_media params[:id]
    render text: ''
  end

  def unlike
    client.unlike_media params[:id]
    render text: ''
  end

end
