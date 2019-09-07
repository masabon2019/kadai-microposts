class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :followings, :followers, :likes]
  
  def index
    @users = User.order(id: :desc).page(params[:page]).per(25)
  end

  def show
    
    #表示しているユーザー　/users/:id
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(id: :desc).page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    #saveとif文判定を同時に行っている
    if @user.save
      flash[:success] = 'ユーザーを登録しました。'
      redirect_to @user
      #render_to ("users/#{@user.id}")
    else
      flash.now[:danger] = 'ユーザーの登録に失敗しました。'
      render :new
    end
  end
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end
  
  def likes
    @user = User.find(params[:id])
    @favorite_posts = @user.favorite_posts.page(params[:page])
    counts(@user)
  end
  

  private
    
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
