class DashboardCardComponent < ViewComponent::Base
  renders_one :body
  def initialize(title:)
    @title = title
  end
end
