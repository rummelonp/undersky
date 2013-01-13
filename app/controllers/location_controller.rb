class LocationController < ApplicationController
  def recent
    id = params.delete :id
    response = client.location_recent_media id, params
    @photos = response.data
    @pagination = response.pagination
    @location = client.location id
    @locations = client.location_search @location.latitude, @location.longitude
    @locations.delete(@location)
  end

  def nearby
  end

  def search
    lat = params.delete :lat
    lng = params.delete :lng
    @locations = client.location_search lat, lng
    respond_to do |format|
      format.json { render json: @locations.to_json }
      format.html { render layout: false }
    end
  end

end
