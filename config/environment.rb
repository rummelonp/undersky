# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Undersky::Application.initialize!

Instagram.configure do |config|
  config.client_id = '*** client_id ***'
  config.client_secret = '*** client_secret ***'
end
