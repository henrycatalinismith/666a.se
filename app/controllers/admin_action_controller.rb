class AdminActionController < ActionController::Base
  before_action :set_admin_locale

  private

    def set_admin_locale
      I18n.locale = :en
    end
end
