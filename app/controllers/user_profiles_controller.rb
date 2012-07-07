class UserProfilesController < ApplicationController
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
  	@profile = UserProfile.find(params[:id])
  	render 'new'
  end

  def update
    @profile = UserProfile.find(params[:id])
    if @profile.update_attributes(params[:user_profile])
      flash[:success] = "Profile updated"
      redirect_to current_user
    else
      render 'new'
    end  	
  end

end
