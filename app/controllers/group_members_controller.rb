class GroupMembersController < ApplicationController
  before_filter :signed_in_user
  before_filter :group_admin?, only: [:new, :create, :update]
  before_filter :correct_user, only: :destroy

  def create
  	@group = Group.find(params[:group_id])
  	@member = GroupMember.new
  	@member.group_id = params[:group_id]
	  @member.user_id = params[:user_id]
	  @member.role = "student"
	  if @member.save
		 flash[:success] = "Application accepted"
		 #delete the application
		 GroupApplication.find_by_group_id_and_user_id(params[:group_id], params[:user_id]).destroy
	  end
		redirect_to @group
  end

  def destroy
    @member.destroy
    redirect_to all_groups_path
  end

  def update
  	@member = GroupMember.find(params[:id])
    respond_to do |format|
      if @member.update_attributes(role: params[:role])
        flash[:success] = "Membership updated successfully!"
        format.html  { redirect_to(:back) }
      else
        flash[:success] = "Update failed!"
        format.html  { redirect_to(:back) }
      end
    end
  end

private

  def correct_user
    @member = GroupMember.find_by_group_id_and_user_id(params[:id], current_user.id)
    redirect_to root_path if @member.nil?
  end

  def group_admin?
    @group = Group.find(GroupMember.find(params[:user_id]).group_id)
  	@group.group_members.find_by_user_id(current_user.id).role == "admin"
  end

end
