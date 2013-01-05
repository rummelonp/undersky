module Instagram
  class Client
    def user_follows(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      id = args.first || "self"
      response = get("users/#{id}/follows", options)
      response
    end

    def user_followed_by(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      id = args.first || "self"
      response = get("users/#{id}/followed-by", options)
      response
    end

    def user_recent_media(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      id = args.first || "self"
      response = get("users/#{id}/media/recent", options)
      response
    end
  end
end
