json.array!(@user_hours) do |json, user_hour|
  json.partial! user_hour
end