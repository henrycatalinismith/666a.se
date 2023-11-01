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

  def update
    @element = Legal::Element.find_by(element_code: params[:id])
    if @element.update(params[:element].permit(:element_type, :element_index, :element_code, :element_text))
      flash[:notice] = "element updated"
      redirect_to "/admin/legal/elements/#{@element.element_code}"
    end
  end

  def new
    @revision = Legal::Revision.find_by(revision_code: params[:revision_code])
    @document = @revision.document
    @element = @revision.elements.new
    @index = @revision.elements.count
    @prev = @revision.elements.order(element_index: :desc).first

    if @prev.element_code.match(/\AK\dP\d\Z/) then
      @element.element_type = "md"
      @element.element_code = "#{@prev.element_code}S1"
    elsif @prev.element_code.match(/\AK\dP\dS\d\Z/) then
      smatch = @prev.element_code.match(/\A(K\dP\dS)(\d)\Z/) 
      @element.element_type = "md"
      @element.element_code = "#{smatch[1]}#{smatch[2].to_i+1}"
    end
  end

  def create
    @revision = Legal::Revision.find_by(revision_code: params[:element][:revision_code])
    if @revision.nil?
      raise ActionController::RoutingError.new('Not Found')
    end
    @element = @revision.elements.new(params[:element].permit(:element_type, :element_index, :element_code, :element_text))
    pmatch = @element.element_code.match(/P(\d)\Z/)
    if pmatch and @element.element_text.empty? then
      @element.element_text = "#{pmatch[1]} §"
    end
    @element.save
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