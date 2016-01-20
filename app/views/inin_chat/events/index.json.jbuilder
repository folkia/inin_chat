json.events do |json|
  json.array! @events[:events] do |event|
    json.type event.type
    json.sequence_number event.sequence_number
    json.participant_type event.participant_type
    json.participant_id event.participant_id
    json.content event.content
  end
end
