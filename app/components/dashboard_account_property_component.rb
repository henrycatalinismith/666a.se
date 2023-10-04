class DashboardAccountPropertyComponent < ViewComponent::Base
  def initialize(name:, value:, href:)
    @name = name
    @value = value
    @href = href
  end
end
