class GroupMembersController < ApplicationController
  before_filter :signed_in_user
  before_filter :teacher?, only: [:new, :create, :update]
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
  	@user = User.find(params[:id])
    @member = GroupMember.find_by_user_id_and_group_id(@user.id, params[:group_id])
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

  def teacher?
    if params.has_key?("group_id")
      @group = Group.find_by_id(params[:group_id])
    else
      @group = Group.find_by_id(params[:id])
    end
    GroupMember.teacher?(current_user.id, @group.id)
  end

end
