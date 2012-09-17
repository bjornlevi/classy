require 'will_paginate/array'

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
    @user_feed = (@user.posts + @user.blurts).sort_by(&:updated_at).reverse.paginate(page: params[:page])
    #@created_tags = @user.posts.tag_counts_on(:tags).order(:name)
    #@given_tags = @user.owned_tags(:tags).order(:name)
    @all_tags = Post.tag_counts.order(:name)
    @group_tags = Group.tag_counts.order(:name)
    @typeahead_tags = @all_tags.map(&:name)
    @user_tags = @user.owned_tags(:tags).order(:name)

    r = Read.created.where(:user_id => @user.id)
    if r.count > 0
      @reads = Read.by_user(@user, r.first.created_at, r.last.created_at)
      @read_range = (0..@reads.max).step(5).to_a
      @x_axis = []
      Date.parse(r.last.created_at.to_s).downto(Date.parse(r.first.created_at.to_s)) do |date|
        @x_axis << (@x_axis.length % 7 == 0 ? date.strftime("%b %d") : '')
      end
      @chart_url = Gchart.line(
        :title => "Participation by user: " + @user.name,
        :size => "450x150",
        :data => @reads, 
        :axis_with_labels => 'x,y',
        :axis_labels => [@x_axis.reverse, @read_range])
    else
      @reads = []
      @read_range = []
      @x_axis = []
      @chart_url = ''
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

end
