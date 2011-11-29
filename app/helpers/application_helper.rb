module ApplicationHelper
  def client
    @client ||= Instagram.client
  end

  def photo_tag(photo, size)
    image = photo.images.send(size.to_sym)
    image_tag image.url, {
      alt: caption_text(photo),
      width: image.width,
      height: image.height,
    }
  end

  def caption_text(photo)
    photo.caption.text unless photo.caption.blank?
  end
end
