require 'will_paginate/array'
require 'matrix'

class UsersController < ApplicationController
  before_filter :signed_in_user, 
    only: [:index, :edit, :update, :change_password, :update_password, :destroy, :following, :followers]
  before_filter :correct_user,
    only: [:edit, :update, :change_password, :update_password]

  def new
  	@user = User.new
  end

  def show
    @user = User.find(params[:id])
    @blurts = current_user.blurts.build if signed_in?
    @user_feed = group_filter((@user.posts + @user.blurts).sort_by(&:updated_at)).reverse.paginate(page: params[:page])
    #@created_tags = @user.posts.tag_counts_on(:tags).order(:name)
    #@given_tags = @user.owned_tags(:tags).order(:name)
    @all_tags = Post.tag_counts.order(:name)
    @group_tags = Group.tag_counts.order(:name)
    @typeahead_tags = @all_tags.map(&:name)
    @user_tags = @user.owned_tags(:tags).order(:name)
    @stats = {}
    @stats[:posts] = @user.posts.count
    @stats[:tags] = @user.owned_tags(:tags).count
    @stats[:likes] = @user.likes.count
    @stats[:comments] = @user.comments.count
    @stats[:bookmarks] = @user.bookmarks.count
    @user_groups = GroupMember.user_groups(current_user)
    @group_tags = @user_groups.map{|g|g.tag_counts.order(:id)}.flatten

    r = Read.created.where(:user_id => @user.id)
    if r.count > 0
      @reads = Read.by_user(@user, r.first.created_at, r.last.created_at)
      @read_range = (0..@reads.max).step(10).to_a

      p = @user.posts.map{|i|i.created_at.strftime("%b %d")}
      @posts = (r.first.created_at.to_date..r.last.created_at.to_date).map do |date|
        action = p.count(date.strftime("%b %d"))
        action || 0
      end

      #self_meta_data = (Comment.joins(:post).where('comments.user_id = ? and posts.user_id = ?', @user.id, @user.id)+
      #  ActsAsTaggableOn::Tagging.joins('left outer join posts on posts.id = taggable_id').where('tagger_id = ? and posts.user_id = ? and taggable_type ="Post"', @user.id, @user.id)).map{|i|i.created_at.strftime("%b %d")}
      #other_meta_data = (Like.find_all_by_user_id(@user.id)+
      #  Comment.joins(:post).where('comments.user_id = ? and posts.user_id != ?', @user.id, @user.id)+
      #  Bookmark.find_all_by_user_id(@user.id)+
      #  ActsAsTaggableOn::Tagging.joins('left outer join posts on posts.id = taggable_id').where('tagger_id = ? and posts.user_id != ? and taggable_type ="Post"', @user.id, @user.id)).map{|i|i.created_at.strftime("%b %d")}
      
      #@self_meta_values = (r.first.created_at.to_date..r.last.created_at.to_date).map do |date|
      #  action = self_meta_data.count(date.strftime("%b %d"))
      #  action || 0
      #end
      #@other_meta_values = (r.first.created_at.to_date..r.last.created_at.to_date).map do |date|
      #  action = other_meta_data.count(date.strftime("%b %d"))
      #  action || 0
      #end

      self_comments = Comment.joins(:post).where('comments.user_id = ? and posts.user_id = ?', @user.id, @user.id).map{|i|i.created_at.strftime("%b %d")}
      self_tags = ActsAsTaggableOn::Tagging.joins('left outer join posts on posts.id = taggable_id').where('tagger_id = ? and posts.user_id = ? and taggable_type ="Post"', @user.id, @user.id).map{|i|i.created_at.strftime("%b %d")}
      other_like = Like.find_all_by_user_id(@user.id).map{|i|i.created_at.strftime("%b %d")}
      other_comment = Comment.joins(:post).where('comments.user_id = ? and posts.user_id != ?', @user.id, @user.id).map{|i|i.created_at.strftime("%b %d")}
      other_bookmark = Bookmark.find_all_by_user_id(@user.id).map{|i|i.created_at.strftime("%b %d")}
      other_tag = ActsAsTaggableOn::Tagging.joins('left outer join posts on posts.id = taggable_id').where('tagger_id = ? and posts.user_id != ? and taggable_type ="Post"', @user.id, @user.id).map{|i|i.created_at.strftime("%b %d")}


      self_comment_values = (r.first.created_at.to_date..r.last.created_at.to_date).map do |date|
        action = self_comments.count(date.strftime("%b %d"))
        action || 0
      end
      self_tag_values = (r.first.created_at.to_date..r.last.created_at.to_date).map do |date|
        action = self_tags.count(date.strftime("%b %d"))
        action || 0
      end

      other_like_values = (r.first.created_at.to_date..r.last.created_at.to_date).map do |date|
        action = other_like.count(date.strftime("%b %d"))
        action || 0
      end
      other_comment_values = (r.first.created_at.to_date..r.last.created_at.to_date).map do |date|
        action = other_comment.count(date.strftime("%b %d"))
        action || 0
      end
      other_bookmark_values = (r.first.created_at.to_date..r.last.created_at.to_date).map do |date|
        action = other_bookmark.count(date.strftime("%b %d"))
        action || 0
      end
      other_tag_values = (r.first.created_at.to_date..r.last.created_at.to_date).map do |date|
        action = other_tag.count(date.strftime("%b %d"))
        action || 0
      end

      s_c_v = Vector.elements(self_comment_values)
      s_t_v = Vector.elements(self_tag_values)
      o_c_v = Vector.elements(other_comment_values)
      o_l_v = Vector.elements(other_like_values)
      o_b_v = Vector.elements(other_bookmark_values)
      o_t_v = Vector.elements(other_tag_values)

      self_comment_bar = s_c_v.to_a
      self_tags_bar = (s_c_v + s_t_v).to_a

      other_comment_bar = o_c_v.to_a
      other_tags_bar = (o_c_v + o_t_v).to_a
      other_likes_bar = (o_c_v + o_t_v + o_l_v).to_a
      other_bookmarks_bar = (o_c_v + o_t_v + o_l_v + o_b_v).to_a

      @x_axis = []
      Date.parse(r.last.created_at.to_s).downto(Date.parse(r.first.created_at.to_s)) do |date|
        @x_axis << (@x_axis.length % 14 == 0 ? date.strftime("%b %d") : '')
      end

      @reads_chart_url = Gchart.line(
        :title => "Reads: " + @user.name,
        :size => "450x150",
        :data => [@reads, @posts], 
        :axis_with_labels => 'x,y',
        :axis_labels => [@x_axis.reverse, @read_range],
        :line_colors => ["FF0000", "00FF00"],
        :legend => ["Reads", "Posts"])
      @self_chart_url = Gchart.bar(
        :title => "Self: " + @user.name,
        :size => "450x150",
        :data => [self_comment_bar, self_tags_bar], 
        :axis_with_labels => 'x,y',
        :axis_labels => [@x_axis.reverse, @read_range],
        :bar_colors => ["FF0000","00FF00"],
        :bar_width_and_spacing => '3,1',
        :legend => ["Comments", "Tags"])
      @other_chart_url = Gchart.bar(
        :title => "Other: " + @user.name,
        :size => "450x150",
        :data => [other_comment_bar, other_tags_bar, other_likes_bar, other_bookmarks_bar], 
        :axis_with_labels => 'x,y',
        :axis_labels => [@x_axis.reverse, @read_range],
        :bar_colors => ["FF0000","00FF00","0000FF","FF6600"],
        :bar_width_and_spacing => '3,1',
        :legend => ["Comments", "Tags", "Likes", "Bookmarks"])
      @personal_chart_url = Gchart.bar(
        :title => "Activity for: " + @user.name,
        :size => "450x150",
        :data => [other_comment_bar, other_tags_bar, other_likes_bar, other_bookmarks_bar], 
        :axis_with_labels => 'x,y',
        :axis_labels => [@x_axis.reverse, @read_range],
        :bar_colors => ["FF0000","00FF00","0000FF","FF6600"],
        :bar_width_and_spacing => '3,1',
        :legend => ["Comments", "Tags", "Likes", "Bookmarks"])
    else
      @reads = []
      @read_range = []
      @x_axis = []
      @participation_chart_url = ''
    end

  rescue Exception => e
    flash[:error] = e.message.to_s
    render 'error'
  end
  
  def index
    @user ||= current_user
    @users = User.order(:email).paginate(:page => params[:page])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      #automatically add the new user to the default Public group.
      GroupMember.create(user_id: @user.id, group_id: Group.first, role: "student")
      flash[:success] = "Welcome to CLASSY!"
      redirect_to @user
    else
      render new_user_path
    end
  end

  def edit
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.friends.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.inverse_friends.paginate(page: params[:page])
    render 'show_follow'
  end

private

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def group_filter(feed)
    current_user_groups = current_user.groups.pluck(:group_id)
    feed.select do |i|
      if i.class == Post
        current_user_groups.include?(i.group_id)
      end
    end
  end

end
