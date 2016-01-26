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
        chat_id: parsed_response['chat']['chatID'],
        status: {
          type: parsed_response['chat']['status']['type']
        }
      }
      response_hash[:events] =
        parsed_response['chat']['events'].map { |event_params|
          Event.from_api(event_params)
        }.compact if parsed_response['chat']['events']
      new(response_hash)
    end

    def success?
      status[:type] == 'success'
    end

    def failure?
      !success?
    end

    private

    def attributes=(attributes)
      attributes.each do |attribute, value|
        self.send("#{attribute}=", value)
      end
    end
  end
end
