class AdminController < ApplicationController
  layout "internal"

  def index
    @days = Day.reverse_chronological
  end

  def days
    @days = Day.reverse_chronological
  end

  def day
    @day = Day.find_by(date: params[:date])
  end

  def day_job
    @day = Day.find_by(date: params[:date])
    SearchJob.perform_later(@day.date, cascade: true, notify: true)
    redirect_to "/admin/#{@day.date.strftime("%Y-%m-%d")}"
    flash[:notice] = "job queued"
  end

  def stats
  end

  def policies
    @policies = Policy.all
  end

  def new_policy
    @policy = Policy.new
    if request.post? then
      @policy = Policy.create(params[:policy].permit(:name, :slug, :icon, :body))
      if @policy.valid? then
        redirect_to "/admin/policies"
        flash[:notice] = "policy created"
      end
    end
  end

  def edit_policy
    @policy = Policy.find_by(slug: params[:slug])
    if request.patch? then
      if @policy.update(params[:policy].permit(:name, :slug, :icon, :body)) then
        flash[:notice] = "policy updated"
      end
    end
  end

  def posts
    @posts = Post.all
  end

  def new_post
    @post = Post.new
    if request.post? then
      @post = Post.create(params[:post].permit(:title, :slug, :date, :body_en, :body_sv, :description))
      if @post.valid? then
        redirect_to "/admin/posts"
        flash[:notice] = "post created"
      end
    end
  end

  def edit_post
    @post = Post.find_by(slug: params[:slug])
    if request.patch? then
      if @post.update(params[:post].permit(:title, :slug, :date, :body_en, :body_sv, :description)) then
        flash[:notice] = "post updated"
      end
    end
  end
end
