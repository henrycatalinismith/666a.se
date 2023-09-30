class NotificationEmailComponent < ViewComponent::Base
  def initialize(format:, user:, result:)
    @format = format
    @user = user
    @result = result
  end
end
