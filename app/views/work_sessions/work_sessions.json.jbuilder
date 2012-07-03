json.array!(@work_sessions) do |json, work_session|
  json.partial! work_session
end