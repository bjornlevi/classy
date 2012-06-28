class GroupApplicationsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user, only: [:destroy]

  def create
  	if params[:group]
  		GroupApplication.create({user_id: current_user.id, group_id: params[:group]})
  	else
  		flash[:error] = "Application or group error"
  	end
    redirect_to all_groups_path
  end

  def destroy
    GroupApplication.find_by_group_id_and_user_id(params[:id], current_user.id).destroy
    flash[:success] = "Application deleted"
    redirect_to all_groups_path
  end

private

  def correct_user
    if !GroupApplication.exists?(group_id: params[:id], user_id: current_user.id) 
      flash[:error] = "Not allowed to change other users applications"
      redirect_to all_groups_path
    end
  end

end
