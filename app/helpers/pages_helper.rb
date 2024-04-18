
module PagesHelper
  def render_page(markdown, data = {})
    @data = data
    renderer = PageRender.new(@data)
    redcarpet = Redcarpet::Markdown.new(renderer, :tables => true)
    redcarpet.render(markdown)
  end

  def is_active_path?(path)
    if path == request.path then
      return true
    end
    sections = {
      "/about" => [
        "/accessibility",
        "/privacy",
        "/terms",
      ],
      "/news" => [
        "/night-work-tech-and-swedish-labour-law",
        "/incident-report",
        "/english-translations-of-swedish-laws",
        "/launch-announcement",
      ],
      "/dashboard" => [],
    }
    return sections[path].include?(request.path)
  end 
end

class PageRender < Redcarpet::Render::HTML
  def initialize(data)
    super
    @data = data
  end

  def header(text, header_level)
    case header_level
    when 1
      if @data["date"] then
        %(
          <div class="flex flex-col gap-2 pb-8 border-b border-gray-300 not-prose">
            <h1 class="text-3xl font-bold font-extralight">
              #{text}
            </h1>
  
            <div class="flex items-center divide-x-2 divide-gray-300">
              <time class="pr-4 text-gray-500" datetime="#{@data["date"].strftime("%Y-%m-%d")}">
                #{@data["date"].strftime("%Y-%m-%d")}
              </time>
  
              <div class="pl-4 flex flex-row gap-2 items-center">
                <img
                  class="w-6 h-6 rounded-full"
                  src="/henry-32.jpeg"
                  alt="Photo of Henry"
                />
                <span class="pr-3 font-medium text-gray-500 ">
                  Henry
                </span>
              </div>
            </div>
  
          </div>
        )
      else 
        %(<h1 class="text-3xl font-bold font-extralight mb-8 pb-8 border-b border-gray-300">#{text}</h1>)
      end
    else
      %(<h#{header_level} class="text-2xl font-bold font-bold mt-8 mb-6">#{text}</h#{header_level}>)
    end
  end

  def link(href, title, text)
    %(<a class="text-blue-700 underline" href="#{href}">#{text}</a>)
  end

  def table(header, body)
    %(<table class="mb-8"><thead>#{header}</thead><tbody>#{body}</tbody></table>)
  end

  def table_row(content)
    %(<tr class="border-b border-gray-300">#{content}</tr>)
  end

  def table_cell(content, alignment, header)
    if header then
      %(<th class="text-left">#{content}</th>)
    else
      %(<td class="align-top py-4 first:pr-4">#{content}</td>)
    end
  end
end