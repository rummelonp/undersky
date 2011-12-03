class LikesController < ApplicationController
  before_filter :authenticate

  def likes
    data = client.media_likes params[:id]
    render json: data.to_json
  end

  def like
  end

  def unlike
  end

end
