require "flipper/adapters/active_record"

class CanAccessFlipperUI
  def self.matches?(request)
    current_user = request.env["warden"].user
    current_user.present? && current_user.respond_to?(:admin?) && current_user.admin?
  end
end

Flipper.configure do |config|
  # config.environment = Rails.env
  config.adapter { Flipper::Adapters::ActiveRecord.new }
end
