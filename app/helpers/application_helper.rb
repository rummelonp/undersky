module ApplicationHelper
  def client
    @client ||= Instagram.client
  end

  def authenticated?
    session[:access_token].present?
  end

  def photo_tag(photo, size)
    image = photo.images.send(size.to_sym)
    image_tag image.url, {
      alt: caption_text(photo),
      width: image.width,
      height: image.height,
    }
  end

  def link_to_external(text, url, options = {})
    link_to text, url, {rel: 'external nofollow', target: '_blank'}.merge(options)
  end

  def caption_text(photo)
    photo.caption.text unless photo.caption.blank?
  end
end
