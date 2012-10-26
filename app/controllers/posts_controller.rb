class PostsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user,   only: :destroy
  before_filter :group_access, only: :show
  after_filter :read_logging, only: :show

  def index
    @posts = Post.all
    @tags = Post.tag_counts_on(:tags).map(&:name)
    respond_to do |format|
      format.html  # index.html.erb
      format.json  { render :json => {posts: @posts, tags: @tags} }
    end
  end

  def show
    @comments = @post.comments
    @user = User.find(@post.user)
    @all_tags = Post.tag_counts.order(:name)
    @group_tags = Group.tag_counts.order(:name)
    @typeahead_tags = @all_tags.map(&:name)
    @post_tags = @post.tag_counts.order(:name)
    @user_tags = @post.owner_tags_on(current_user, :tags)

    r = Read.created.where(:post_id => @post.id)
    if is_admin?(current_user) and r.count > 0
      @reads = Read.by_user(@user, r.first.created_at, r.last.created_at)
      @read_range = (0..@reads.max).step(5).to_a
      @x_axis = []
      Date.parse(r.last.created_at.to_s).downto(Date.parse(r.first.created_at.to_s)) do |date|
        @x_axis << (@x_axis.length % 7 == 0 ? date.strftime("%b %d") : '')
      end
      @chart_url = Gchart.line(
        :title => "Post reads",
        :size => "450x150",
        :data => @reads, 
        :axis_with_labels => 'x,y',
        :axis_labels => [@x_axis.reverse, @read_range])
    end
  rescue
    render 'error'
  end

  def new
    @post = Post.new
    @user_bookmarks = current_user.bookmarks.order(&:created_at).reverse.map { |bm| Post.find(bm.post_id) }
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
      @post.content = params[:post][:content]
      @post.group_id = params[:post][:group_id]
      @post.user_id = current_user.id
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
      flash[:error] = "Error saving post."
      render 'static_pages/home'
    end
  end

  def edit
    @post = Post.find(params[:id])
    @user_bookmarks = current_user.bookmarks.order(&:created_at).reverse.map { |bm| Post.find(bm.post_id) }
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
    #@post.destroy
    flash[:error] = "Deleting posts not allowed at the moment, edit it's content instead."
    respond_to do |format|
      format.html { redirect_back_or root_path }
      format.json { head :no_content }
    end
  end

  def add_tag
    p = Post.find(params[:post_id])
    @tag_name = params[:tag]
    new_tags = p.tags_from(current_user).append(@tag_name).join(',')
    current_user.tag(p, with: new_tags, on: :tags)
    @tag_response = "tag added"
  end

  def remove_tag
    p = Post.find(params[:id])
    tag = ActsAsTaggableOn::Tag.find_by_name(params[:tag])
    t = ActsAsTaggableOn::Tagging.find_by_tag_id_and_tagger_id_and_taggable_id_and_taggable_type(tag.id, current_user.id, p.id, "Post").delete
    flash[:success] = "Tag deleted"
    redirect_to p
  end

  private

    def correct_user
      @post = current_user.posts.find_by_id(params[:id])
      redirect_to root_path if @post.nil?
    end

    def read_logging
      if @post.user != current_user
        Read.create!(user_id: current_user.id, post_id: params[:id])
      end
    rescue
    end

    def group_access
      @post = Post.find(params[:id])
      redirect_to root_path unless current_user.groups.pluck(:group_id).include?(@post.group.id)
    end
end