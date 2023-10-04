class UsersController < ApplicationController
  layout "internal"

  def update
    if current_user.update(params[:user].permit(:name, :email, :locale)) then
      redirect_to "/dashboard"
      flash[:notice] = "user was updated."
    end
  end

  def email
  end

  def language
  end

  def name
  end
end
