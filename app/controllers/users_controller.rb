class UsersController < ApplicationController
  layout "internal"

  def account
    @user = current_user
  end

  def dashboard
    @user = current_user
    @subscriptions = @user.subscriptions
  end

  def email
    if request.patch?
      if current_user.update(params[:user].permit(:email)) then
        redirect_to "/dashboard"
        flash[:notice] = "email updated"
      end
    end
  end

  def language
    if request.patch?
      if current_user.update(params[:user].permit(:language)) then
        redirect_to "/dashboard"
        flash[:notice] = "language updated"
      end
    end
  end

  def name
    if request.patch?
      if current_user.update(params[:user].permit(:name)) then
        redirect_to "/dashboard"
        flash[:notice] = "name updated"
      end
    end
  end
end
