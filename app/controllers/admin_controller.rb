require 'gchart'

class AdminController < ApplicationController
	before_filter :signed_in_user
	before_filter :admin_user?, only: :update

	def index
		@groups = Group.all
	end

	def update
		u = User.find(params[:id])
		a = Admin.find_by_user_id(u.id)
		if a.nil?
			Admin.create(user_id: u.id)
			flash[:success] = "Updated admin list"
		else
			if current_user.id == u.id
				flash[:error] = "Can't remove your own admin access"
			else
				a.destroy
				flash[:success] = "Updated admin list"
			end
		end
		redirect_to users_path
	end

private
	def admin_user?
		redirect_to admin_index_path if Admin.find_by_user_id(current_user.id).nil?
	end
end
