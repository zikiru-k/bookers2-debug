class BookCommentsController < ApplicationController
  def create
    # URLのbook_idから関連する本を見つける
    book = Book.find(params[:book_id])
    # 現在のユーザーによる新しいコメントを作成する
    @comment = current_user.book_comments.new(book_comment_params)
    # 作成したコメントに関連する本のIDを設定し、保存
    @comment.book_id = book.id
    @comment.save
    # redirect_to request.referer
  end

  def destroy
    @comment = BookComment.find(params[:id]).destroy
    # redirect_to request.referer
  end

  private
  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end
