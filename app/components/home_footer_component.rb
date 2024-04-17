# frozen_string_literal: true

class HomeFooterComponent < ViewComponent::Base
  def initialize
    @policies = [
      { name: "Accessibility", slug: "accessibility" },
      { name: "Privacy Policy", slug: "privacy" },
      { name: "Terms of Service", slug: "terms" }
    ]
  end
end
