
if ENV['RAILS_ENV'] == 'production'
  ENV['RAILS_RELATIVE_URL_ROOT'] = '/gpx'
end

# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Gpx::Application.initialize!
