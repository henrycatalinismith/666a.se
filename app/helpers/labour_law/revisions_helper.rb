module LabourLaw::RevisionsHelper
  def both_sides()
    "max-w-[50%] overflow-hidden"
  end

  def left_classes()
    "pr-1 md:pr-4"
  end

  def right_classes()
    "pl-1 md:pl-4"
  end

  def revision_notice_markdown(markdown)
    renderer = LabourLawRevisionNoticeRender.new()
    redcarpet = Redcarpet::Markdown.new(renderer, tables: true)
    redcarpet.render(markdown)
  end
end

class LabourLawRevisionNoticeRender < Redcarpet::Render::HTML
  def header(text, header_level)
    "<h#{header_level} class=\"text-lg mdtext-2xl font-bold\">#{text}</h#{header_level}>"
  end

  def link(link, title, content)
    "<a href=\"#{link}\" title=\"#{title}\" class=\"text-blue-700 underline\">#{content}</a>"
  end
end
