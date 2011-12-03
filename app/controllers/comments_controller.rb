class CommentsController < ApplicationController
  before_filter :authenticate

  def comments
    data = client.media_comments params[:id]
    render json: data.to_json
  end

  def create_comment
  end

  def delete_comment
  end

end
