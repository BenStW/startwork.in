json.user_id user.id
json.(user, :fb_ui,:first_name,:last_name)
json.current_user current_user.id == user.id
json.friend current_user.is_friend?(user)
