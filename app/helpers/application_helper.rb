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

    def mine?(id)
      session[:user] && session[:user][:id] == id
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

  module PhotoHelper
    def caption_text(photo)
      photo.caption.text.strip unless photo.caption.blank?
    end

    def photo_tag(photo, size)
      image = photo.images.send(size.to_sym)
      image_tag image.url, {
        alt: caption_text(photo),
        width: image.width,
        height: image.height,
      }
    end

    def tags_tag(text)
      return nil if text.blank?
      text.gsub(/\#([a-zA-Z0-9_]*)/) do
        tag = $1
        return nil if tag.blank?
        content_tag :a, "##{tag}", href: tags_url(name: tag)
      end
    end

    def emoji_tag(text)
      return nil if text.blank?
      result = ''
      space = raw '&nbsp;'
      text.each_char do |c|
        if c >= "\uE001" && c <= "\uE537"
          unicode = format('%x', c.unpack('U').first)
          result += content_tag(:span, space, :class => "emoji emoji_#{unicode}")
        else
          result += c
        end
      end
      raw result
    end
  end

  include AuthorizeHelper
  include TagHelper
  include PhotoHelper
end
