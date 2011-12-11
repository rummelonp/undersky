module ApplicationHelper
  module AuthorizeHelper
    def client
      unless @client
        if authenticated?
          @client = Instagram.client access_token: session[:access_token]
        else
          @client = Instagram.client
        end
      end

      @client
    end

    def authenticated?
      session[:access_token].present?
    end
  end

  module PhotoHelper
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

    def pretty_time(time)
      i = (Time.now - time.created_time.to_i).to_i
      case i
      when 0
        'just now'
      when 1..59
        i.to_s + 's'
      when 60..3540
        (i / 60).to_i.to_s + 'm'
      when 3541..82800
        ((i + 99) / 3600).to_i.to_s + 'h'
      when 82801..518400
        ((i + 800) / (60 * 60 * 24)).to_i.to_s + 's'
      else
        ((i + 180000) / (60 * 60 * 24 * 7)).to_i.to_s + 'w'
      end
    end
  end

  module TagHelper
    def link_to_external(text, url, options = {})
      link_to text, url, {rel: 'external nofollow', target: '_blank'}.merge(options)
    end

    def nav_link_tag(text, url)
      if request.url == url || request.fullpath == url
        content_tag 'li', link_to(text, url), :class => 'active'
      else
        content_tag 'li', link_to(text, url)
      end
    end
  end

  include AuthorizeHelper
  include PhotoHelper
  include TagHelper
end
