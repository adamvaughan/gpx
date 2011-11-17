class ApplicationController < ActionController::Base
  protect_from_forgery

  def render_404
    render "#{Rails.root}/public/404.html", :layout => false, :status => :not_found
  end
end
