module PoliciesHelper
  def render_policy(text)
    renderer = PolicyRender.new()
    redcarpet = Redcarpet::Markdown.new(renderer, :tables => true)
    redcarpet.render(text)
  end
end

class PolicyRender < Redcarpet::Render::HTML
  def header(text, header_level)
    case header_level
    when 1
      %(<h1 class="text-3xl font-bold">#{text}</h1>)
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