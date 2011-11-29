class MediaController < ApplicationController
  def popular
    @photos = client.media_popular
  end

end
