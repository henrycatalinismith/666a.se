show_schema = Dry::Schema.Params { }

class WorkEnvironment::DocumentsController < ApplicationController
  def index
    index_schema =
      Dry::Schema.Params do
        required(:FromDate).filled(:string, format?: /\d{4}-\d{2}-\d{2}/)
        required(:ToDate).filled(:string, format?: /\d{4}-\d{2}-\d{2}/)
        required(:sortDirection).filled(:string, format?: /\Aasc|desc\z/)
        required(:sortOrder).filled(:string, included_in?: ["Dokumentdatum"])
        required(:page).filled(:integer)
      end

    show_schema =
      Dry::Schema.Params do
        required(:id).filled(:string, format?: /\A\d{4}\/\d+-\d+\z/)
      end

    index_query = index_schema.call(params.to_unsafe_h)
    show_query = show_schema.call(params.to_unsafe_h)

    if index_query.errors.empty?
      @documents =
        WorkEnvironment::Document
          .where("document_date >= ?", index_query[:FromDate])
          .where("document_date <= ?", index_query[:ToDate])
          .limit(10)
      @document = nil
    elsif show_query.errors.empty?
      @document =
        WorkEnvironment::Document.find_by_document_code(show_query[:id])
      @documents = []
    else
      @documents = []
      @document = nil
    end
  end
end
