class Api::BaseController < ActionController::Metal
  include ActionController::UrlFor
  include ActionController::Rendering
  include ActionController::Renderers::All
  include ActionController::ConditionalGet
  include ActionController::MimeResponds
  include ActionController::Rescue
  include ActionController::Instrumentation

  include Rails.application.routes.url_helpers

  append_view_path "#{Rails.root}/app/views"
end
