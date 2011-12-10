class CommentsController < ApplicationController
  before_filter :authenticate

  def comments
    response = client.media_comments params[:id]
    render json: response.to_json
  end

  def create_comment
    response = client.create_media_comment params[:id], params[:text]
    render json: response.to_json
  end

  def delete_comment
  end

end
