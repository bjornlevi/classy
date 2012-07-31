class GroupsController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  before_filter :signed_in_user
  before_filter :correct_user, only: [:destroy, :edit, :update]
  before_filter :admin_access, only: [:new, :create]

  def index
    @groups = current_user.groups

    respond_to do |format|
      format.html  # index.html.erb
      format.json  { render :json => @posts }
    end    
  end

  #lists open groups of current_user
  def all
    @groups = Group.where(status: "open")
  end

  def show
    @group = Group.find(params[:id])
    @applications = GroupApplication.where(group_id: @group.id)
    @group_members = @group.users.order('users.email')
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
      @header_groups << @group
      GroupMember.create(group_id: @group.id, user_id: @group.user_id, role: "admin")
      flash[:success] = "Group created!"
      redirect_to groups_path
    else
      flash[:error] = @group.errors
      redirect_to new_group_path
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        #you can only edit the current_group
        @current_group = @group.name
        flash[:success] = "Group updated successfully!"
        format.html  { redirect_to(@group) }
        format.json  { head :no_content }
      else
        format.html  { render :action => "edit" }
        format.json  { render :json => @group.errors,
                      :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groups/toggle_status/:id
  def toggle_status
    @group = Group.find(params[:id])
    if @group.status == "open"
      @group.status = "closed"
    else
      @group.status = "open"
    end

    if @group.save
      flash[:success] = "Group status updated"
    else
      flash[:error] = "Group status change failed"
    end  
    redirect_to @group
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group = Group.find(params[:id])
    @group.status = "closed"

    respond_to do |format|
      format.html { redirect_to groups_path }
      format.json { head :no_content }
    end
  end

  private

    def correct_user
      @group = Group.find(params[:id])#.group_admin?(current_user)
      redirect_to root_path if @group.nil?
    end

    def admin_access
      redirect_to groups_path, flash: {error: "Access restricted!"} if !Admin.exists?(current_user)
    end

    def record_not_found
      redirect_to all_groups_path, flash: {error: "Group not found!"}
    end

end