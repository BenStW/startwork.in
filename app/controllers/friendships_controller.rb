class FriendshipsController < ApplicationController
  
  def index
    @friendships = current_user.friendships
    @users = User.all - current_user.friends - [current_user]  
       
  end
  
  def create
 #  if current_user.friendships.count>2
 #    flash[:alert] = "Currently you can have only 3 friends."
 #    redirect_to friendships_url
 #  else      
      @friendship = current_user.friendships.build(:friend_id => params[:friend_id])
      @inverse_friendship = current_user.inverse_friendships.build(:user_id => params[:friend_id])
     
      if (@friendship.save and @inverse_friendship.save)
        flash[:notice] = "Added friend #{@friendship.friend.name}."
        redirect_to friendships_url
      else
        flash[:alert] = "Unable to add friend."
        redirect_to friendships_url
      end
  end

  def destroy
    @friendship = current_user.friendships.find(params[:id])
    @inverse_friendship = current_user.inverse_friendships.find_by_user_id(@friendship.friend)
    @friendship.destroy
    @inverse_friendship.destroy
    flash[:notice] = "Removed friend #{@friendship.friend.name}."
    redirect_to friendships_url
  end

  
end
