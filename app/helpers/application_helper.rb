module ApplicationHelper
  def client
    @client ||= Instagram.client
  end
end
