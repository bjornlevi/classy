class ReferenceController < ApplicationController
before_filter :signed_in_user

  def create
    @post = Post.find(params[:reference][:post_id])
    @post.add_reference(current_user)
    respond_to do |format|
      format.html { redirect_to @post }
      format.js
    end
  end

  def destroy
    @post = Post.find(params[:reference][:post_id])
    @post.destroy_reference(current_user)
    respond_to do |format|
      format.html { redirect_to @post }
      format.js
    end
  end
end
