class Admin::LabourLaw::ElementsController < AdminController
  layout "internal"

  def index
    @revision = LabourLaw::Revision.find(params[:revision_id])
    @document = @revision.document
    @elements = @revision.elements
  end

  def show
    @element = LabourLaw::Element.find(params[:id])
    @revision = @element.revision
    @document = @revision.document
  end

  def edit
    @element = LabourLaw::Element.find(params[:id])
    @revision = @element.revision
    @document = @revision.document
  end

  def update
    @element = LabourLaw::Element.find(params[:id])
    if @element.update(params[:element].permit(
      :element_type,
      :element_index,
      :element_text,
      :element_chapter,
      :element_section,
      :element_paragraph,
      :element_slug,
      ))
      flash[:notice] = "element updated"
      redirect_to "/admin/labour_law/elements/#{@element.id}"
    end
  end

  def new
    @revision = LabourLaw::Revision.find(params[:revision_id])
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
      @element.element_chapter = @prev.element_chapter
      @element.element_section = @prev.element_section
    end
  end

  def create
    @revision = LabourLaw::Revision.find_by(revision_code: params[:element][:revision_code])
    if @revision.nil?
      raise ActionController::RoutingError.new("Not Found")
    end
    @element = @revision.elements.new(params[:element].permit(
      :element_type,
      :element_index,
      :element_text,
      :element_chapter,
      :element_section,
      :element_paragraph,
      :element_slug,
    ))

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

      redirect_to "/admin/labour_law/elements/#{@element.id}"
      flash[:notice] = "element created"
    end
  end

  def destroy
    @element = LabourLaw::Element.find(params[:id])
    @revision = @element.revision
    @element.destroy
    flash[:notice] = "element deleted"
    redirect_to admin_labour_law_elements_path(revision_id: @revision.id)
  end
end
