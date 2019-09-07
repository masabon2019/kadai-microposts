class FavoritesController < ApplicationController
  before_action :require_user_logged_in

  def create
    micropost = Micropost.find(params[:favorite_post])
    current_user.favorite(micropost)
    flash[:success] = 'お気に入りに登録しました。'
    redirect_to micropost.user
  end

  def destroy
    micropost = Micropost.find(params[:favorite_post])
    current_user.unfavorite(micropost)
    flash[:danger] = 'お気に入りを解除しました。'
    redirect_to micropost.user
  end
end
