class FavoritesController < ApplicationController
  def create
    # BookモデルからFavoriteモデルの:book_idと同じパラメーター(id)を探して
    # `book`変数には、検索された結果が代入されます。
    # これにより、IDを指定して特定の`Book`レコードを取得することができます。
    @book  = Book.find(params[:book_id])

    # current_user.favorites：現在ログインしているユーザーに関連付けられた`favorites`という関連モデルを取得するため
    # new：新しい`favorite`オブジェクトを作成
    # book_id: book.id：作成された`favorite`オブジェクトの`book_id`属性に`book`のIDを設定しています。
    # `book`は2行目で取得した`Book`モデルのインスタンスであり、そのIDを`favorite`オブジェクトの`book_id`属性に関連付けることができます。
    favorite = current_user.favorites.new(book_id: @book.id)
    favorite.save
    # redirect_to request.referer
  end

  def destroy
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by(book_id: @book.id)
    favorite.destroy
    # redirect_to request.referer
  end
end
