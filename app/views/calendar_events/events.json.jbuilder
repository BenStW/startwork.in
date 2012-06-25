json.array!(@calendar_events) do |json, calendar_event|
  json.partial! calendar_event
end