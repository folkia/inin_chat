# TODO: remove this ugly hack with conditionals
json.events do |json|
  json.array! @events[:events] do |event|
    json.type event.type if event.type
    json.sequence_number event.sequence_number if event.sequence_number
    json.participant_type event.participant_type if event.participant_type
    json.participant_id event.participant_id if event.participant_id
    json.content event.content if event.content
  end
end
