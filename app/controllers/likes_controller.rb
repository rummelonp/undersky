class LikesController < ApplicationController
  before_filter :authenticate

  def likes
    response = client.media_likes params[:id]
    render json: response.to_json
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
