class CommentsController < ApplicationController
  before_filter :authenticate

  def comments
    @comments = client.media_comments params[:id]
    respond_to do |format|
      format.json { render json: @comments.to_json }
      format.html { render layout: false }
    end
  end

  def create_comment
    @comment = client.create_media_comment params[:id], params[:text]
    @comment.from ||= session[:user]
    respond_to do |format|
      format.json { render json: @comment.to_json }
      format.html { render layout: false }
    end
  end

  def delete_comment
    client.delete_media_comment params[:id], params[:comment_id]
    render text: ''
  end

end
