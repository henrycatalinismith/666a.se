class Admin::LabourLaw::ElementsController < AdminController
  layout "internal"

  def edit
    @document = LabourLaw::Document.find_by(document_code: params[:document_code])
    @revision = @document.revisions.find_by(revision_code: params[:revision_code])
    @element = @revision.elements.find_by(element_code: params[:element_code])
    if request.patch? then
      if @element.update(params[:element].permit(:element_type, :element_index, :element_code, :element_text))
        flash[:notice] = "element updated"
      end
    end
  end

  def update
    @element = LabourLaw::Element.find(params[:id])
    if @element.update(params[:element].permit(:element_type, :element_index, :element_code, :element_text))
      flash[:notice] = "element updated"
      redirect_to "/admin/labour_law/elements/#{@element.id}"
    end
  end

  def new
    @revision = LabourLaw::Revision.find_by(revision_code: params[:revision_code])
    @position = params[:position] || "end"
    @document = @revision.document
    @element = @revision.elements.new

    case @position
    when "end"
      @index = @revision.elements.count

    when "after"
      @index = LabourLaw::Element.find(params[:element_id]).element_index + 1
    end

    @prev = @revision.elements.order(element_index: :desc).first

    type = params[:type]
    if @revision.elements.count == 0 then
      return
    elsif type == "new_paragraph" then
      npmatch = @prev.element_code.match(/\AK(\d+)P(\d+)/)
      if !npmatch.nil? then
        @element.element_type = "h3"
        @element.element_code = "K#{npmatch[1]}P#{npmatch[2].to_i + 1}"
        @element.element_text = "#{npmatch[2].to_i + 1} §"
      end
      npmatch = @prev.element_code.match(/\AP(\d+)/)
      if !npmatch.nil? then
        @element.element_type = "h3"
        @element.element_code = "P#{npmatch[1].to_i + 1}"
        @element.element_text = "#{npmatch[1].to_i + 1} §"
      end
    elsif @prev.element_code.match(/\AK+\dP\d+\Z/) then
      @element.element_type = "md"
      @element.element_code = "#{@prev.element_code}S1"
    elsif @prev.element_code.match(/\AP\d+\Z/) then
      @element.element_type = "md"
      @element.element_code = "#{@prev.element_code}S1"
    elsif @prev.element_code.match(/\AP\d+[a-z]\Z/) then
      @element.element_type = "md"
      @element.element_code = "#{@prev.element_code}S1"
    elsif @prev.element_code.match(/\AK\d+P\d+S\d+\Z/) then
      smatch = @prev.element_code.match(/\A(K\d+P\d+S)(\d+)\Z/)
      @element.element_type = "md"
      @element.element_code = "#{smatch[1]}#{smatch[2].to_i+1}"
    elsif @prev.element_code.match(/\AP\d+S\d+\Z/) then
      smatch = @prev.element_code.match(/\A(P\d+S)(\d+)\Z/)
      @element.element_type = "md"
      @element.element_code = "#{smatch[1]}#{smatch[2].to_i+1}"
    elsif @prev.element_code.match(/\AP\d+[a-z]S\d+\Z/) then
      smatch = @prev.element_code.match(/\A(P\d+[a-z]S)(\d+)\Z/)
      @element.element_type = "md"
      @element.element_code = "#{smatch[1]}#{smatch[2].to_i+1}"
    end
  end

  def create
    @revision = LabourLaw::Revision.find_by(revision_code: params[:element][:revision_code])
    if @revision.nil?
      raise ActionController::RoutingError.new("Not Found")
    end
    @element = @revision.elements.new(params[:element].permit(:element_type, :element_index, :element_code, :element_text))
    pmatch = @element.element_code.match(/P(\d+)\Z/)
    if pmatch and @element.element_text.empty? then
      @element.element_text = "#{pmatch[1]} §"
    end
    @element.save
    if @element.valid? then
      matching_index = LabourLaw::Element.where(
        revision_id: @element.revision_id,
        element_index: @element.element_index
      ).where.not(id: @element.id).first
      if !matching_index.nil?
        LabourLaw::Element
          .where(revision_id: @element.revision_id)
          .where("element_index >= ?", @element.element_index)
          .where("id != ?", @element.id)
          .update_all("element_index = element_index + 1")
      end

      @element.translations.create(
        translation_locale: "en",
        translation_text: "",
      )

      if @element.element_type == "h3" and @element.element_code.match(/P\d/) then
        match = @element.element_text.match(/\A(\d+) ([a-z])?/)
        english = "Section #{match[1]}#{match[2]}"
        @element.translations.first.update(translation_text: english)
      end

      redirect_to "/admin/labour_law/elements/#{@element.id}"
      flash[:notice] = "element created"
    end
  end

  def show
    @element = LabourLaw::Element.find(params[:id])
    @revision = @element.revision
    @document = @revision.document
  end
end
