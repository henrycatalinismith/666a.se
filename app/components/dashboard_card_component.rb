class DashboardCardComponent < ViewComponent::Base
  renders_one :action
  renders_one :body
  def initialize(title:)
    @title = title
  end
end
