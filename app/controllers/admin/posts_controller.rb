class Admin::PostsController < ApplicationController
  layout "internal"

  def index
    @posts = Post.all
  end

  def edit
    @post = Post.find_by(slug: params[:slug])
    if request.patch? then
      if @post.update(params[:post].permit(:name, :slug, :icon, :body)) then
        flash[:notice] = "post updated"
      end
    end
  end

  def new
    @post = Post.new
    if request.post? then
      @post = Post.create(params[:post].permit(:name, :slug, :icon, :body))
      if @post.valid? then
        redirect_to "/admin/posts"
        flash[:notice] = "post created"
      end
    end
  end
end