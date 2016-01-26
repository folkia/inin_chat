module InteractionWebTools
  class Event
    attr_accessor :type,
                  :sequence_number,
                  :participant_type,
                  :participant_id,
                  :content,
                  :state

    def initialize(opts = {})
      @type = opts[:type]
      @sequence_number = opts[:sequence_number]
      @participant_type = opts[:participant_type]
      @participant_id = opts[:participant_id]
      @content = opts[:content]
      @state = opts[:state]
    end

    def self.from_api(opts)
      new(
        type: opts['type'],
        content: opts['value'],
        participant_id: opts['participantID'],
        participant_type: opts['participantType'],
        sequence_number: opts['sequenceNumber'],
        state: opts['state']
      )
    end
  end
end
