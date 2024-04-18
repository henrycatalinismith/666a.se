module ApplicationHelper
  def h1(&block)
    "<h1 class=\"text-lg md:text-3xl font-bold\">#{capture(&block)}</h1>".html_safe
  end

  def policies
    [
      { name: "Accessibility", slug: "accessibility" },
      { name: "Privacy Policy", slug: "privacy" },
      { name: "Terms of Service", slug: "terms" }
    ]
  end

  def posts
    [
      { text: "Night Work, Tech, And Swedish Labour Law", href: "/night-work-tech-and-swedish-labour-law" },
      { text: "Incident Report", href: "/incident-report" },
      { text: "English translations of Swedish laws", href: "/english-translations-of-swedish-laws" },
      { text: "Announcing 666a", href: "/launch-announcement" }
    ]
  end
end
