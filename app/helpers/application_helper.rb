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
      tag_pattern = /(#[a-zA-Z0-9_]*)/
      quote = '#x27' # ' => &#x27;
      html_safe = text.html_safe?
      text.split(tag_pattern).map { |c|
        if c =~ tag_pattern && c != quote
          tag = c.sub('#', '')
          c = content_tag :a, "##{tag}", 'class' => 'tag', href: tags_url(name: tag)
        elsif html_safe
          c
        else
          ERB::Util.html_escape c
        end
      }.join.html_safe
    end

    def emoji_tag(text)
      return nil if text.blank?
      space = '&nbsp;'.html_safe
      html_safe = text.html_safe?
      text.each_char.map { |c|
        if c >= "\uE001" && c <= "\uE537"
          unicode = format('%x', c.unpack('U').first)
          content_tag(:span, space, :class => "emoji emoji_#{unicode}")
        elsif html_safe
          c
        else
          ERB::Util.html_escape c
        end
      }.join.html_safe
    end
  end

  include AuthorizeHelper
  include TagHelper
  include PhotoHelper
end
