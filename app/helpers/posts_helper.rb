module PostsHelper
  def render_post(markdown, date)
    renderer = PostRender.new(date:)
    redcarpet = Redcarpet::Markdown.new(renderer, :tables => true)
    redcarpet.render(markdown)
  end
end

class PostRender < Redcarpet::Render::HTML
  def initialize(date:)
    super
    @date = date
  end

  def header(text, header_level)
    case header_level
    when 1
      %(
        <div class="flex flex-col gap-2">
          <h1 class="text-3xl font-bold">#{text}</h1>

          <div class="flex items-center divide-x-2 divide-gray-300">
            <time class="pr-4 text-gray-500" datetime="#{@date.strftime("%Y-%m-%d")}">
              #{@date.strftime("%Y-%m-%d")}
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
      %(<h#{header_level} class="text-xl font-bold">#{text}</h#{header_level}>)
    end
  end

  def link(href, title, text)
    %(<a class="text-blue-700 underline" href="#{href}">#{text}</a>)
  end

  def table(header, body)
    %(<table><thead>#{header}</thead><tbody>#{body}</tbody></table>)
  end

  def table_row(content)
    %(<tr class="">#{content}</tr>)
  end

  def table_cell(content, alignment, header)
    if header then
      %(<th class="text-left">#{content}</th>)
    else
      %(<td class="align-top py-4 first:pr-4">#{content}</td>)
    end
  end

  def footnote_ref(number)
     %(<sup id="fnref#{number}"><a class="text-blue-700 font-bold" href="#fn#{number}">[#{number}]</a></sup>)
  end

  def footnotes(content)
    %(<hr class="h-px bg-gray-400 border-0 mt-4" /><div class="py-4">#{content}</div>)
  end

  def footnote_def(content, number)
    %(
      <li id="fn#{number}" class="flex flex-row gap-2">
        <span class="font-bold">[#{number}]</span>
        #{content}
      </li>
    )
  end
end