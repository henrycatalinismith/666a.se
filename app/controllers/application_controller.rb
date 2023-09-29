class ApplicationController < ActionController::Base
  before_action :set_variables

  def set_variables
    @field = "w-64 flex flex-col"
  end

  protected

  def after_sign_in_path_for(resource)
    "/dashboard"
  end

  around_action :switch_locale

  def switch_locale(&action)
    # locale = params[:locale] || I18n.default_locale
    locale = extract_locale_from_accept_language_header
    I18n.with_locale(locale, &action)
  end

  private
  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end

end
