class HomeController < ApplicationController
  def index
    @page_title = "666:a"
    @policies = [
      { name: "Accessibility", slug: "accessibility" },
      { name: "Privacy Policy", slug: "privacy" },
      { name: "Terms of Service", slug: "terms" }
    ]
  end
end
