class AdminController < ApplicationController
  before_action :check_admin_user

  private

    def check_admin_user
      unless current_user.role?("admin")
        flash[:alert] = "You can't be here!"
        redirect_to root_path
      end
    end
end
