class GroupApplicationsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user, only: [:destroy]
  before_filter :store_location

  def create
  	if params[:group]
  		GroupApplication.create({user_id: current_user.id, group_id: params[:group]})
  	else
  		flash[:error] = "Application or group error"
  	end
    redirect_to all_groups_path
  end

  def destroy
    GroupApplication.find_by_group_id_and_user_id(params[:id], params[:user_id]).destroy
    flash[:success] = "Application deleted"
    redirect_to all_groups_path
  end

private

  def correct_user
    application_owner = GroupApplication.exists?(group_id: params[:id], user_id: current_user.id)
    user = Group.find(params[:id]).group_members.find_by_user_id(current_user.id)
    if user
      group_admin = user.role
    end
    if application_owner or group_admin
      flash[:success] = "All good"
    else
      flash[:error] = "Not allowed to change other users applications"
      redirect_to all_groups_path
    end
  end

end
