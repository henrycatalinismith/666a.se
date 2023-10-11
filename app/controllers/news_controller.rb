require "redcarpet"

class ArticleRender < Redcarpet::Render::HTML
  def initialize(date:)
    super
    @date = date
  end

  def header(text, header_level)
    case header_level
    when 1
      %(
        <div>
          <h1 class="text-3xl font-bold">#{text}</h1>
          <time class="text-xl text-gray-500" datetime="#{@date.strftime("%Y-%m-%d")}">
            #{@date.strftime("%Y-%m-%d")}
          </time>
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
end

class NewsController < ApplicationController
  def show
    article(params[:year], params[:month], params[:day], params[:slug])
    render template: "news/show", layout: "internal"
  end

  private

  def article(year, month, day, slug)
    @date = Date.parse("#{year}-#{month}-#{day}")
    filename = Rails.root.join("news", "#{year}-#{month}-#{day}-#{slug}.en.md")
    markdown = File.read(filename)
    renderer = ArticleRender.new(date: @date)
    redcarpet = Redcarpet::Markdown.new(renderer, :tables => true)
    @html = redcarpet.render(markdown)
  end
end
