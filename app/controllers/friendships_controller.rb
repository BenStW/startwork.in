class FriendshipsController < ApplicationController
  
  def index
    
    @friends = current_user.friends.sort_by!{|friend| friend.name}
 #  friends_fb_uis =  @friends.map(&:fb_ui)
 #
 #  facebook_user = FbGraph::User.new('me', :access_token => session[:facebook_token]).fetch() 
 #  fb_friends = facebook_user.friends
 #  @facebook_friends = []
 #     facebook_user.friends.each do |fb_friend|   
 #     @facebook_friends.push(fb_friend) unless friends_fb_uis.include?(fb_friend.identifier)
 #  end
 #  @facebook_friends.sort_by!{|friend| friend.name}
 #  
#    @maxi = FbGraph::User.fetch('100003847064481')
    
  end
  
# def create_all_fb_friends
#   friends = current_user.friends.sort_by!{|friend| friend.name}
#   friends_fb_uis =  friends.map(&:fb_ui)
#
#   facebook_user = FbGraph::User.new('me', :access_token => session[:facebook_token]).fetch() 
#   fb_friends = facebook_user.friends
#   facebook_friends = []
#      facebook_user.friends.each do |fb_friend|   
#      facebook_friends.push(fb_friend) unless friends_fb_uis.include?(fb_friend.identifier)
#   end
#   facebook_friends.each do |fb_friend|
#     friend = User.find_or_create_fb_friend(fb_friend)
#     Friendship.create_reciproke_friendship(current_user,friend)
#   end
#   redirect_to friendships_url    
# end
# 
  
#  def create
#    limit = 10
#    if(current_user.friends.count>=limit)
#      flash[:alert] = t("friendships.index.limit",:limit => limit )
#    else
#      friendship = current_user.friendships.build(:friend_id => params[:friend_id])
#      inverse_friendship = current_user.inverse_friendships.build(:user_id => params[:friend_id])
#      
#      if (friendship.save and inverse_friendship.save)
#        WorkSession.optimize_single_work_sessions(friendship.friend)
#        WorkSession.optimize_single_work_sessions(current_user)
#        flash[:notice] = t("friendships.index.added_as_friend",:name => friendship.friend.name )
#      else
#        flash[:alert] = t("friendships.index.unable_to_add_friend",:name => friendship.friend.name )        
#      end
#    end
#    redirect_to friendships_url
#  end
#  
#  def create_with_fb_friend
#    friend = User.find_or_create(params[:fb_ui]) 
#    Friendship.create_reciproke_friendship(current_user, friend) 
#    flash[:notice] = t("friendships.index.added_as_friend",:name => friend.name )
#    redirect_to friendships_url
#  end
#
#  def destroy
#    friendship = current_user.friendships.find(params[:id])
#    inverse_friendship = current_user.inverse_friendships.find_by_user_id(friendship.friend)
#    friendship.destroy
#    inverse_friendship.destroy
#    WorkSession.split_work_session_when_not_friend(current_user)
#    WorkSession.split_work_session_when_not_friend(friendship.friend)    
#    flash[:notice] = t("friendships.index.removed_as_friend",:name => friendship.friend.name )    
#    redirect_to friendships_url
#  end

  
end
