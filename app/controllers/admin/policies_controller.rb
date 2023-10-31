class Admin::PoliciesController < AdminController
  layout "internal"

  def index
    @policies = Policy.all
  end

  def edit
    @policy = Policy.find_by(slug: params[:slug])
    if request.patch? then
      if @policy.update(params[:policy].permit(:name, :slug, :icon, :body)) then
        flash[:notice] = "policy updated"
      end
    end
  end

  def new
    @policy = Policy.new
    if request.post? then
      @policy = Policy.create(params[:policy].permit(:name, :slug, :icon, :body))
      if @policy.valid? then
        redirect_to "/admin/policies"
        flash[:notice] = "policy created"
      end
    end
  end
end