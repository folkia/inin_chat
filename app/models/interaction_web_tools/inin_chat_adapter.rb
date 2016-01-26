module InteractionWebTools
  class IninChatAdapter
    def start(locale: 'sv',
              chat_info: chat_initiation_payload,
              target: InteractionWebTools.config.chat_target)
      begin
        dict = {
          "target" => target,
          "participant" => {
            "name" => "Customer",
            "credentials" => ""
          },
          "supportedContentTypes" => "text/plain",
          "emailAddress" => "",
          "targetType" => "Workgroup",
          "customInfo" => chat_info,
          "language" => locale,
          "transcriptRequired" => false,
          "clientToken" => "deprecated"
        }

        res = make_post(
          URI("#{server}/chat/start"),
          dict
        )

        JSON.parse(res.body)['chat']['participantID']
      end
    end

    def poll(id)
      begin
        uri = URI("#{server}/chat/poll/#{id}")

        http = Net::HTTP.new(uri.host, uri.port)
        req = Net::HTTP::Get.new(uri)
        res = http.request(req)

        parsed_response = JSON.parse res.body
        parse_poll_response(parsed_response)
      rescue StandardError => e
        Rails.logger.error "HTTP Request failed (#{e.message})"
      end
    end

    def send_message(id, message)
      begin
        res = make_post(
          URI("#{server}/chat/sendMessage/#{id}"),
          {
            "message" => message,
            "contentType" => "text/plain"
          }
        )
        parsed_response = JSON.parse res.body
        parse_poll_response(parsed_response)
      end
    end

    private

    def server
      InteractionWebTools.config.inin_server
    end

    def chat_initiation_payload
      InteractionWebTools.config.chat_additional_information.call
    end

    def make_post(uri, dict)
      http = Net::HTTP.new(uri.host, uri.port)

      body = JSON.dump(dict)

      req = Net::HTTP::Post.new(uri)
      req.add_field "Content-Type", "application/json"
      req.body = body

      http.request(req)
    rescue StandardError => e
      Rails.logger.error "HTTP Request failed (#{e.message})"
    end

    def parse_poll_response(response)
      {
        status: response['chat']['status']['type'],
        events: parse_events_from_poll_response(response)
      }
    end

    def parse_events_from_poll_response(response)
      return unless response['chat']['status']['type'] == 'success'
      response['chat']['events'].map { |event_params|
        Event.from_api(event_params)
      }.compact
    end
  end
end
