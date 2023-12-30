class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def index
    @users = User.all
    @book = Book.new
  end

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new

    @today_book = @books.created_today
    @yesterday_book = @books.created_yesterday
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week

    # 空の配列を定義しています。この配列には投稿された本の数を１日ずつ追加します。
    @this_week_book_counts = []
    6.downto(0) do |n|
      # pushメソッドは配列に要素を追加するメソッド
      # pushの引数にn日前に投稿された本の数を渡し、@this_week_book_counts配列に追加しています！
      @this_week_book_counts.push(@books.where(created_at: n.day.ago.all_day).count)
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book)
    else
      @user = current_user
      @books = Book.all
      render :index
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  def posts_on_date
    # リクエストの中からユーザーIDを取得し、データベースからユーザー情報を取得
    user = User.includes(:books).find(params[:user_id])
    # リクエストの中から指定された日付を取得し、日付オブジェクトに変換
    date = Date.parse(params[:created_at])
    # ユーザーが指定した日に投稿した本（books）をデータベースから検索
    @books = user.books.where(created_at: date.all_day)
    # 検索結果を表示するためのビュー（posts_on_date_form）にデータを送る
    render :posts_on_date_form
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
