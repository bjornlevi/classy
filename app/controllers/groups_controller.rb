class GroupsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user, only: :destroy

  def index
    @groups = Group.all

    respond_to do |format|
      format.html  # index.html.erb
      format.json  { render :json => @posts }
    end    
  end

  def show
    @group = Group.find(params[:id])
  end

  def new
    @group = Group.new

    respond_to do |format|
      format.html  # new.html.erb
      format.json  { render :json => @group }
    end    
  end

  def create
    @group = current_user.groups.build(params[:group])
    @group.status = "open"
    @group.user_id = current_user.id
    if @group.save
      flash[:success] = "Group created!"
      redirect_to root_path
    end
  end

  def destroy

  end

  private

    def correct_user
      @group = current_user.groups.find_by_id(params[:id])
      redirect_to root_path if @group.nil?
    end
end