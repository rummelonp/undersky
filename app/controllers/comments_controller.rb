class CommentsController < ApplicationController
  before_filter :authenticate

  def comments
    data = client.media_comments params[:id]
    render json: data.to_json
  end

  def create_comment
    data = client.create_media_comment params[:id], params[:text]
    render json: data.to_json
  end

  def delete_comment
  end

end
