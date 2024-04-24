module ApplicationHelper
  def open_source?
    Flipper.enabled?(:open_source, current_user)
  end

  def h1(&block)
    "<h1 class=\"text-lg md:text-3xl font-bold\">#{capture(&block)}</h1>".html_safe
  end

  def policies
    policies = [
      { name: "Accessibility", slug: "accessibility" },
      { name: "Privacy Policy", slug: "privacy" },
      { name: "Security Policy", slug: "security" },
      { name: "Terms of Service", slug: "terms" },
    ]

    if open_source?
      policies.insert(1, { name: "License", slug: "license" })
      policies.insert(1, { name: "Code of Conduct", slug: "conduct" })
    end

    return policies
  end

  def posts
    [
      {
        text: "Night Work, Tech, And Swedish Labour Law",
        href: "/night-work-tech-and-swedish-labour-law"
      },
      { text: "Incident Report", href: "/incident-report" },
      {
        text: "English translations of Swedish laws",
        href: "/english-translations-of-swedish-laws"
      },
      { text: "Announcing 666a", href: "/launch-announcement" }
    ]
  end

  def docs
    [
      {
        text: "Dependency Version Numbers",
        href: "/dependency-version-numbers"
      },
      { text: "Environment Variables", href: "/environment-variables" },
      {
        text: "Service Architecture Diagram",
        href: "/service-architecture-diagram"
      },
      { text: "Work Environment Jobs", href: "/work-environment-jobs" }
    ]
  end
end
