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

  rescue_from Instagram::Error do |e|
    logger.info e
    if request.xhr?
      render text: e.message, status: 400
    else
      @notice = e.message
      render template: 'error/client', status: 400
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
    @message = e.message.split(':')[-2..-1].join(':')
    if request.xhr?
      render text: message, status: status
    else
      render template: template, status: status
    end
  end
end
