class FavoritesController < ApplicationController
   before_action :require_user_logged_in

  def create
    #1:該当のmicripostを取得する   　　↓_button.htmlと合わせる
    @micropost = Micropost.find(params[:micropost_id])
    id = current_user.id
    Favorite.create(user_id: id, micropost_id: @micropost.id)
    flash[:success] = 'お気に入りに追加しました。'
    redirect_to root_url
  end
  
  def destroy
    #1:該当のmicripostを取得する
    @micropost = Micropost.find(params[:micropost_id])
    #2:取得した記事のIDとユーザーのIDをfavoriteテーブルから削除する
    id = current_user.id
    # @micropost = :micropost_id
    Favorite.find_by(user_id: id, micropost_id: @micropost.id).destroy
     
    # user = User.find(params[@micropost])
    # current_user.unfavorite(micropost)
    flash[:success] = 'お気に入りを解除しました。'
    redirect_to root_url
  end
end
