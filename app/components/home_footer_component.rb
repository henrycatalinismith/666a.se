# frozen_string_literal: true

class HomeFooterComponent < ViewComponent::Base
  def initialize
    @policies = [
      { text: "accessibility", href: "/accessibility" },
      { text: "privacy", href: "/privacy" },
      { text: "terms", href: "/terms" }
    ]
  end
end
