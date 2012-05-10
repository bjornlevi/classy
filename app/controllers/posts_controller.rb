class PostsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user,   only: :destroy

  def index
    @posts = Post.all

    respond_to do |format|
      format.html  # index.html.erb
      format.json  { render :json => @posts }
    end
  end

  def show
    @post = Post.find(params[:id])
    @user = User.find(@post.user)
  rescue
    render 'error'
  end

  def new
    @post = Post.new

    respond_to do |format|
      format.html  # new.html.erb
      format.json  { render :json => @post }
    end  
  end

  def create
    @post = current_user.posts.build(params[:post])
    if @post.save
      flash[:success] = "Post created!"
      redirect_to root_path
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
   
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