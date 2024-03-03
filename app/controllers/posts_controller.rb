require "redcarpet"

class PostsController < ApplicationController
  def show
    @posts = Post.reverse_chronological
    post(params[:year], params[:month], params[:day], params[:slug])
    render template: "posts/show", layout: "internal"
  end

  def index
    @posts = Post.chronological
  end

  private

  def post(year, month, day, slug)
    @date = Date.parse("#{year}-#{month}-#{day}")
    @post = Post.find_by(date: @date, slug: slug)
    if @post.nil? then
      raise ActionController::RoutingError.new('Not Found')
    end
    @body = @post.body_en
    if I18n.locale == :sv and !@post.body_sv.empty? then
      @body = @post.body_sv
    end
  end
end
