class TagsController < ApplicationController
  def recent
    name = params.delete(:name)
    response = client.tag_recent_media name, params.merge(count: 100)
    @photos = response.data
    @pagination = response.pagination
    @tag = client.tag name
  end

end
