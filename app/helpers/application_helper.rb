module ApplicationHelper
  def h1(&block)
    "<h1 class=\"text-lg md:text-3xl font-bold\">#{capture(&block)}</h1>".html_safe
  end

  def policies
    [
      { name: "Accessibility", slug: "accessibility" },
      { name: "Code of Conduct", slug: "conduct" },
      { name: "License", slug: "license" },
      { name: "Privacy Policy", slug: "privacy" },
      { name: "Security Policy", slug: "security" },
      { name: "Terms of Service", slug: "terms" },
    ]
  end

  def posts
    [
      {
        text: "We Maxed Out SendGrid's Free Tier",
        href: "/news/we-maxed-out-sendgrids-free-tier"
      },
      {
        text: "About Arbetsmiljöverket's New Webdiarium",
        href: "/news/about-arbetsmiljoverkets-new-webdiarium"
      },
      {
        text: "Going Open Source",
        href: "/news/going-open-source"
      },
      {
        text: "Night Work, Tech, And Swedish Labour Law",
        href: "/news/night-work-tech-and-swedish-labour-law"
      },
      { text: "Incident Report", href: "/news/incident-report" },
      {
        text: "English translations of Swedish laws",
        href: "/news/english-translations-of-swedish-laws"
      },
      { text: "Announcing 666a", href: "/news/launch-announcement" }
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
