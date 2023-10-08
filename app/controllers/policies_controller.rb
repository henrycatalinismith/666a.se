require "redcarpet"

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
    %(<tr class="">#{content}</tr>)
  end

  def table_cell(content, alignment, header)
    if header then
      %(<th class="text-left">#{content}</th>)
    else
      %(<td class="align-top py-4 first:pr-4">#{content}</td>)
    end
  end
end

class PoliciesController < ApplicationController
  def accessibility
    policy("accessibility")
    render template: "policies/show", layout: "internal"
  end

  def privacy
    policy("privacy")
    render template: "policies/show", layout: "internal"
  end

  def terms
    policy("terms")
    render template: "policies/show", layout: "internal"
  end

  private

  def policy(name)
    filename = Rails.root.join("policies", "#{name}.en.md")
    markdown = File.read(filename)
    renderer = PolicyRender.new()
    redcarpet = Redcarpet::Markdown.new(renderer, :tables => true)
    @policy = name
    @html = redcarpet.render(markdown)
  end
end
