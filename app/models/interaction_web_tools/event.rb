module InteractionWebTools
  class Event
    attr_accessor :type,
                :sequence_number,
                :participant_type,
                :participant_id,
                :content

    def initialize(type:, sequence_number:, participant_type:, participant_id:, content:)
      @type = type
      @sequence_number = sequence_number
      @participant_type = participant_type
      @participant_id = participant_id
      @content = content
    end

    def self.from_api(opts)
      return unless opts['type'] == 'text'
      new(
        type: opts['type'],
        content: opts['value'],
        participant_id: opts['participantID'],
        participant_type: opts['participantType'],
        sequence_number: opts['sequenceNumber']
      )
    end
  end
end
