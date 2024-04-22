class RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  layout "internal"
  # before_action :configure_account_update_params, only: [:update]

  # POST /resource
  def create
    super
    if !current_user.nil? then
      subscription_props = {}
      subscription_props[:account_id] = current_user.id
      if current_user.company_code.match(/\A\d{8}\z/) then
        subscription_props[:subscription_type] = :workplace_subscription
        subscription_props[:workplace_code] = current_user.company_code
      else
        subscription_props[:subscription_type] = :company_subscription
        subscription_props[:company_code] = current_user.company_code
      end
      current_user.subscriptions.create(subscription_props)
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :company_code, :locale])
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end
end
