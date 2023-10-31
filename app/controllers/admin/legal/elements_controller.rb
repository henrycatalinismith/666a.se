class Admin::Legal::ElementsController < AdminController
  layout "internal"

  def edit
    @document = Legal::Document.find_by(document_code: params[:document_code])
    @revision = @document.revisions.find_by(revision_code: params[:revision_code])
    @element = @revision.elements.find_by(element_code: params[:element_code])
    if request.patch? then
      if @element.update(params[:element].permit(:element_type, :element_index, :element_code, :element_text))
        flash[:notice] = "element updated"
      end
    end
  end

  def new
    @revision = Legal::Revision.find_by(revision_code: params[:revision_code])
    @document = @revision.document
    @element = @revision.elements.new
    @index = @revision.elements.count
    @prev = @revision.elements.index_order.last
  end

  def create
    @revision = Legal::Revision.find_by(revision_code: params[:element][:revision_code])
    if @revision.nil?
      raise ActionController::RoutingError.new('Not Found')
    end
    @element = @revision.elements.create(params[:element].permit(:element_type, :element_index, :element_code, :element_text))
    if @element.valid? then
      redirect_to "/admin/legal/elements/#{@element.element_code}"
      flash[:notice] = "element created"
    end
  end

  def show
    @element = Legal::Element.find_by(element_code: params[:id])
    @revision = @element.revision
    @document = @revision.document
  end
end