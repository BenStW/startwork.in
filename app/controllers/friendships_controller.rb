class FriendshipsController < ApplicationController
  
  def index
    @friendships = current_user.friendships.sort_by!{|f| f.friend.name}
    @users = User.all - current_user.friends - [current_user]  
    @users.sort_by!{|u| u.name}       
  end
  
  def create
    friendship = current_user.friendships.build(:friend_id => params[:friend_id])
    inverse_friendship = current_user.inverse_friendships.build(:user_id => params[:friend_id])
    
    if (friendship.save and inverse_friendship.save)
      WorkSession.optimize_single_work_sessions(friendship.friend)
      WorkSession.optimize_single_work_sessions(current_user)
      flash[:notice] = t("friendships.index.added_as_friend",:name => friendship.friend.name )
      redirect_to friendships_url
    else
      flash[:alert] = t("friendships.index.unable_to_add_friend",:name => friendship.friend.name )
      redirect_to friendships_url
    end
    
  end

  def destroy
    friendship = current_user.friendships.find(params[:id])
    inverse_friendship = current_user.inverse_friendships.find_by_user_id(friendship.friend)
    friendship.destroy
    inverse_friendship.destroy
    WorkSession.split_work_session_when_not_friend(current_user)
    WorkSession.split_work_session_when_not_friend(friendship.friend)    
    flash[:notice] = t("friendships.index.removed_as_friend",:name => friendship.friend.name )    
    redirect_to friendships_url
  end

  
end
