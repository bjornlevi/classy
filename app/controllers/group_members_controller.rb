class GroupMembersController < ApplicationController
  def create
  	@group = Group.find(params[:group_id])
  	if is_group_admin?(current_user)
	  	@member = GroupMember.new
	  	@member.group_id = params[:group_id]
		@member.user_id = params[:user_id]
		@member.role = "student"
		if @member.save
			flash[:success] = "Application accepted"
			#delete the application
			GroupApplication.find_by_group_id_and_user_id(params[:group_id], params[:user_id]).destroy
		end
	else
		flash[:error] = "Not authorized"
	end
		redirect_to @group
  end

  def destroy
  end

  def update
  end

  private

  def is_group_admin?(user)
  	@group.group_members.find_by_user_id(current_user.id).role == "admin"
  end
end
