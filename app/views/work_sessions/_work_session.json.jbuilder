json.(work_session, :id,:start_time)
json.users do |json|
  json.array!(work_session.users) do |json, user|
    json.partial! user
  end
end
