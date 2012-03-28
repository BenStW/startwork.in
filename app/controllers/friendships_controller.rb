class FriendshipsController < ApplicationController
  
  def index
    @friendships = current_user.friendships.sort_by!{|f| f.friend.name}
    @users = User.all - current_user.friends - [current_user]  
    @users.sort_by!{|u| u[:name]}
       
  end
  
  def create
    limit = 4
    if current_user.friendships.count>=limit
      flash[:alert] = t("friendships.index.friend_limit", :limit => limit)
      redirect_to friendships_url
    else      
      @friendship = current_user.friendships.build(:friend_id => params[:friend_id])
      @inverse_friendship = current_user.inverse_friendships.build(:user_id => params[:friend_id])
     
      if (@friendship.save and @inverse_friendship.save)
        flash[:notice] = t("friendships.index.added_as_friend",:name => @friendship.friend.name )
        redirect_to friendships_url
      else
        flash[:alert] = t("friendships.index.unable_to_add_friend",:name => @friendship.friend.name )
        redirect_to friendships_url
      end
    end
  end

  def destroy
    @friendship = current_user.friendships.find(params[:id])
    @inverse_friendship = current_user.inverse_friendships.find_by_user_id(@friendship.friend)
    @friendship.destroy
    @inverse_friendship.destroy
    flash[:notice] = t("friendships.index.removed_as_friend",:name => @friendship.friend.name )    
    redirect_to friendships_url
  end

  
end
