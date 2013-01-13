class MediaController < ApplicationController
  def popular
    @photos = client.media_popular
  end

  def search
    lat = params.delete :lat
    lng = params.delete :lng
    response = client.media_search lat, lng
    @photos = response.data
    respond_to do |format|
      format.json { render json: @photos.to_json }
      format.html { render layout: false }
    end
  end

end
