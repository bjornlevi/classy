class GroupApplicationsController < ApplicationController
  def create
  	if signed_in? and params[:group]
  		GroupApplication.create({user_id: current_user, group_id: })
  end

  def destroy
  end
end
