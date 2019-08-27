class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show]
  
  def index
    @users = User.order(id: :desc).page(params[:page]).per(25)
  end

  def show
    @user = User.find(params[:id])
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
  
  private
    
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
