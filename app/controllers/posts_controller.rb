class PostsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user,   only: :destroy

  def index
    @posts = Post.all
    @tags = Post.tag_counts_on(:tags).map(&:name)
    respond_to do |format|
      format.html  # index.html.erb
      format.json  { render :json => {posts: @posts, tags: @tags} }
    end
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
    @user = User.find(@post.user)
    @tags = Post.tag_counts.order(:name)
    @post_tags = @post.tag_counts.order(:name)
  rescue
    render 'error'
  end

  def new
    @post = Post.new
    if params.has_key?(:group_id) and can_post_to?(params[:group_id]) then #and allowed
      @group = Group.find(params[:group_id])
    else
      flash[:error] = "You are not allowed to post to this group"
      redirect_to root_path
      return
    end

    respond_to do |format|
      format.html  # new.html.erb
      format.json  { render :json => @post }
    end  
  end

  def create
    if can_post_to?(params[:post][:group_id]) then
      @post = Post.new
      @post.title = params[:post][:title]
      @post.content = params[:post][:title]
      @post.group_id = params[:post][:group_id]
      @post.user_id = current_user
    else
      flash[:error] = "You can not post to this group"
      redirect_to root_path
      return
    end

    if @post.save
      flash[:success] = "Post created!"
      redirect_to @post
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def edit
    @post = Post.find(params[:id])
    @group = @post.group
  end

  def update
    @post = Post.find(params[:id])
   
    if @post.group_id != params[:post][:group_id].to_i
      flash[:error] = "Invalid group"
      redirect_to @post
      return
    end

    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:success] = "Post updated successfully!"
        format.html  { redirect_to(@post) }
        format.json  { head :no_content }
      else
        format.html  { render :action => "edit" }
        format.json  { render :json => @post.errors,
                      :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_back_or root_path }
      format.json { head :no_content }
    end
  end

  private

    def correct_user
      @post = current_user.posts.find_by_id(params[:id])
      redirect_to root_path if @post.nil?
    end
end