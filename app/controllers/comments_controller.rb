class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @photo = Photo.find(params[:photo_id])
    comment = current_user.comments.new(comment_params)
    comment.photo_id = @photo.id
    if comment.save
      flash.now[:notice] = 'コメントを投稿しました'
    else
      flash.now[:alert] = 'コメントを投稿することができませんした'
    end
  end

  def destroy
    @photo = Photo.find(params[:photo_id])
    Comment.find_by(photo_id: params[:photo_id], id: params[:id]).destroy
    flash.now[:notice] = "コメントを削除しました"
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
