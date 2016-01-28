module InteractionWebTools
  class ChatResponse
    attr_accessor :chat_id,
                  :status,
                  :events

    def initialize(attributes)
      self.attributes = attributes
    end

    def self.parse(string)
      parsed_response = JSON.parse(string)
      response_hash = {
        chat_id: parsed_response['chat']['participantID'],
        status: {
          type: parsed_response['chat']['status']['type']
        }
      }
      response_hash[:events] = parsed_events(parsed_response)
      new(response_hash)
    end

    def success?
      status[:type] == 'success'
    end

    def failure?
      !success?
    end

    def events
      if @events.any? do |event|
        event.state == 'disconnected' &&
          event.type == 'participantStateChanged'
      end
        event = Event.new(
          type: 'text',
          participant_type: 'System',
          content: I18n.t('conversation_ended')
        )
        @events << event 
      end
      @events
    end

    def self.parsed_events(parsed_response)
      if parsed_response['chat']['events']
        parsed_response['chat']['events'].map do |event_params|
          Event.from_api(event_params)
        end.compact
      else
        []
      end
    end

    private

    def attributes=(attributes)
      attributes.each do |attribute, value|
        self.send("#{attribute}=", value)
      end
    end
  end
end
