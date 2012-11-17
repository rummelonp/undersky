class ApplicationController < ActionController::Base
  protect_from_forgery

  include ApplicationHelper::AuthorizeHelper

  def authenticate
    unless authenticated?
      if request.xhr?
        raise Instagram::BadRequest.new 'you are not authorized'
      else
        redirect_to authorize_url(redirect_url: request.fullpath)
      end
    end
  end

  def username_to_id
    if params[:id] =~ /^[0-9]+$/
      id = params.delete :id
      user = client.user id
      Rails.cache.write user.username, user.id
      redirect_to recent_url(id: user.username)
    else
      username = params.delete :id
      id = Rails.cache.read username
      unless id
        users = client.user_search username
        user = users.find {|u| u.username == username}
        id = user.id if user
      end
      if id
        Rails.cache.write username, id
        params[:id] = id
      end
    end
  end

  rescue_from StandardError do |e|
    case e
    when Instagram::Error
      logger.info e
      status = 400
      template = 'error/client'
    else
      logger.error e
      status = 500
      template = 'error/server'
    end
    # Remove Instagram API URI from error messages
    messages = e.message.split(':')
    if messages.size >= 3
      @message = messages[-2..-1].join(':')
    else
      @message = e.message
    end
    if request.xhr?
      render text: @message, status: status
    else
      render template: template, status: status
    end
  end
end
