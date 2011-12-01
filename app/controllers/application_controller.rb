class ApplicationController < ActionController::Base
  protect_from_forgery

  include ApplicationHelper::AuthorizeHelper

  def authenticate
    unless authenticated?
      redirect_to authorize_url(redirect_url: request.fullpath)
    end
  end
end
