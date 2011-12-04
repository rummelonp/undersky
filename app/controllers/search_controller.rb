class SearchController < ApplicationController
  def search
    name = params[:name]
    return unless name

    @users = client.user_search(name)
    @tags = client.tag_search(name)
  end

end
