require 'will_paginate/array'

class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_filter :correct_user,   only: [:edit, :update]

  def new
  	@user = User.new
  end

  def show
    @user = User.find(params[:id])
    @blurts = current_user.blurts.build if signed_in?
    @feed_items = (@user.posts + @user.blurts).paginate(page: params[:page])
  rescue 
    render 'error'
  end
  
  def index
    @user ||= current_user
    @users = User.paginate(:page => params[:page])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the CoBlogger!"
      redirect_to @user
    else
      render 'new'
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
