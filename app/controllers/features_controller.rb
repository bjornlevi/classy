class FeaturesController < ApplicationController
  before_filter :signed_in_user
  before_filter :is_teacher?

  def create
    @post.add_feature(current_user)
    respond_to do |format|
      format.html { redirect_to @post }
      format.js
    end
  end

  def destroy
    @post.destroy_feature(current_user)
    respond_to do |format|
      format.html { redirect_to @post }
      format.js
    end
  end

private

  def is_teacher?
    @post = Post.find(params[:feature][:post_id])
    @group = Group.find(@post.group_id)
    @group.group_members.find_by_user_id(current_user.id).role == "admin" or
    @group.group_members.find_by_user_id(current_user.id).role == "teacher"
  end

end