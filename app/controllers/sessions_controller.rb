class SessionsController < Devise::SessionsController
  layout "internal"

  def create
    super
    flash.delete(:notice)
  end

  def after_sign_in_path_for(resource)
    if !session[:referer].nil? then
      "/#{session[:referer]}"
    else
      "/dashboard"
    end
  end
end