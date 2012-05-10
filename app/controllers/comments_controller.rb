class CommentsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user,   only: :destroy

  def index
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(params[:comment])
    @comment.user = current_user
    if @comment.save
      flash[:success] = "Comment created!"
      redirect_to @post
    else
      render @post
    end
  end

  def destroy
    @comment.destroy
    redirect_back_or @comment.post
  end

  private

    def correct_user
      @comment = current_user.comments.find_by_id(params[:id])
      redirect_to Post.find_by_id(params[:post_id]) if @comment.nil?
    end
end