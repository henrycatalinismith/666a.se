class Admin::UsersController < AdminController
  layout "internal"

  def index
    @users = User.reverse_chronological.all
  end

  def show
    @user = User.find(params[:id])
  end
end
