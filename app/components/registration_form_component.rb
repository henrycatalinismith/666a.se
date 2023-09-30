class RegistrationFormComponent < ViewComponent::Base

  def initialize()
    @resource = User.new
    @resource_name = :user
    @field = "w-64 flex flex-col"
  end

  def main_app
    Rails.application.class.routes.url_helpers
  end

  def devise_mapping
    Devise.mappings[:user]
  end
end
