class AuthorizeController < ApplicationController
  def authorize
    session[:redirect_url] = params[:redirect_url]
    redirect_to Instagram.authorize_url(
      scope: [:comments, :likes, :relationships].join(' '),
      redirect_uri: url_for(:access_token)
    )
  end

  def access_token
    if params.key?(:error)
      raise Instagram::Error.new params[:error]
    end
    response = Instagram.get_access_token(
      params[:code],
      redirect_uri: url_for(:access_token)
    )
    session[:access_token] = response.access_token
    session[:user] = response.user
  rescue Instagram::Error
    session.delete(:access_token)
    session.delete(:user)
  ensure
    unless session[:redirect_url].blank?
      redirect_to session.delete(:redirect_url)
    else
      redirect_to :feed
    end
  end

  def logout
    session.delete(:access_token)
    session.delete(:user)
    redirect_to :index
  end

end
