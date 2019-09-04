class ToppagesController < ApplicationController
  def index
    if logged_in?
      # form_with用
      @micropost = current_user.microposts.build 
      
      #一覧用に取得、インスタンスに代入
      @microposts = current_user.feed_microposts.order(id: :desc).page(params[:page])
    end
  end
end
