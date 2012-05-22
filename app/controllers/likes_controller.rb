class LikesController < ApplicationController
before_filter :signed_in_user

  def create
    @post = Post.find(params[:like][:post_id])
    @post.add_like(current_user)
    respond_to do |format|
      format.html { redirect_to @post }
      format.js
    end
  end

  def destroy
    @post = Post.find(params[:like][:post_id])
    @post.destroy_like(current_user)
    respond_to do |format|
      format.html { redirect_to @post }
      format.js
    end
  end
end