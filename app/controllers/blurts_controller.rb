class BlurtsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user,   only: :destroy

  def index
  end

def create
    @blurt = current_user.blurts.build(params[:blurt])
    if @blurt.save
      flash[:success] = "Blurt created!"
      redirect_to root_path
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @blurt.destroy
    redirect_back_or root_path
  end

  private

    def correct_user
      @blurt = current_user.blurts.find_by_id(params[:id])
      redirect_to root_path if @blurt.nil?
    end
end