class LocationController < ApplicationController
  def recent
    id = params.delete :id
    response = client.location_recent_media id, params
    @photos = response.data
    @pagination = response.pagination
    @location = client.location id
  end
end
