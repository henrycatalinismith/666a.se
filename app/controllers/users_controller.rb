class UsersController < ApplicationController
  layout "internal"

  def account
    @user = current_user
  end

  def dashboard
    @page_title = "666a – dashboard"
    @user = current_user
    @subscriptions = @user.subscriptions
  end

  def delete
    @page_title = "666a – delete account"
    session[:referer] = :delete
    if request.post? and !current_user.nil? and current_user.destroy then
      redirect_to "/", :notice => "BALEETED"
    end
    @user = current_user
  end

  def email
    @page_title = "666a – email"
    if request.patch?
      if current_user.update(params[:user].permit(:email)) then
        redirect_to "/dashboard"
        flash[:notice] = "email updated"
      end
    end
  end

  def language
    @page_title = "666a – language"
    if request.patch?
      if current_user.update(params[:user].permit(:language)) then
        redirect_to "/dashboard"
        flash[:notice] = "language updated"
      end
    end
  end

  def name
    @page_title = "666a – name"
    if request.patch?
      if current_user.update(params[:user].permit(:name)) then
        redirect_to "/dashboard"
        flash[:notice] = "name updated"
      end
    end
  end
end
