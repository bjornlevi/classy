class UserProfilesController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user
  def new
  	@profile = UserProfile.new
  end

  def create
  	@profile = UserProfile.new(params[:user_profile])
  	@profile.user_id = current_user.id
  	if @profile.save
  		flash[:success] = "Profile saved"
  	else
  		flash[:error] = "Error occurred"
  	end
  	redirect_to current_user
  end

  def edit
  	@profile = @user.profile
  	render 'new'
  end

  def update
    @profile = @user.profile
    if @profile.update_attributes(params[:user_profile])
      flash[:success] = "Profile updated"
    else
      flash[:error] = "Update failed"
    end  	
    redirect_to current_user
  end

private

  def correct_user
    @user = current_user
  end
end
