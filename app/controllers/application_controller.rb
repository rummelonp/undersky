class ApplicationController < ActionController::Base
  protect_from_forgery

  include ApplicationHelper::AuthorizeHelper

  def authenticate
    unless authenticated?
      if request.xhr?
        render text: 'is not authenticated', status: 403
      else
        redirect_to authorize_url(redirect_url: request.fullpath)
      end
    end
  end
end
