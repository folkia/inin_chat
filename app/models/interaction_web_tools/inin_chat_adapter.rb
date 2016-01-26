module InteractionWebTools
  class IninChatAdapter
    def server
      InteractionWebTools.config.inin_server
    end

    def start(locale: 'sv',
              chat_info: chat_initiation_payload,
              target: InteractionWebTools.config.chat_target)
      begin
        uri = URI("#{server}/chat/start")

        http = Net::HTTP.new(uri.host, uri.port)

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
        body = JSON.dump(dict)

        req = Net::HTTP::Post.new(uri)
        req.add_field "Content-Type", "application/json"
        req.add_field "Content-Type", "application/json"
        req.body = body

        res = http.request(req)
        puts "Response HTTP Status Code: #{res.code}"
        puts "Response HTTP Response Body: #{res.body}"
        participant_id = JSON.parse(res.body)['chat']['participantID']
      rescue StandardError => e
        puts "HTTP Request failed (#{e.message})"
      end
    end

    def chat_initiation_payload
      InteractionWebTools.config.chat_additional_information.call
    end

    def poll(id)
      begin
        uri = URI("#{server}/chat/poll/#{id}")

        http = Net::HTTP.new(uri.host, uri.port)

        req = Net::HTTP::Get.new(uri)

        res = http.request(req)
        parsed_response = JSON.parse res.body
        return if parsed_response['chat']['status']['type'] == 'failure'
        puts "Response HTTP Status Code: #{res.code}"
        puts "Response HTTP Response Body: #{res.body}"
        parse_poll_response(res)
      rescue StandardError => e
        puts "HTTP Request failed (#{e.message})"
      end
    end

    def send_message(id, message)
      begin
        uri = URI("#{server}/chat/sendMessage/#{id}")

        http = Net::HTTP.new(uri.host, uri.port)

        dict = {
          "message" => message,
          "contentType" => "text/plain"
        }
        body = JSON.dump(dict)

        # Create Request
        req = Net::HTTP::Post.new(uri)
        # Add headers
        req.add_field "Content-Type", "application/json"
        req.add_field "Content-Type", "application/json"
        req.body = body

        res = http.request(req)
        puts "Response HTTP Status Code: #{res.code}"
        puts "Response HTTP Response Body: #{res.body}"
        parse_poll_response(res)
      rescue StandardError => e
        puts "HTTP Request failed (#{e.message})"
      end
    end

    def parse_poll_response(res)
      status = JSON.parse(res.body)['chat']['status']
      return { status: 'failure' } if status == 'failure'
      {
        status: 'success',
        events: parse_events_from_poll_response(res)
      }
    end

    def parse_events_from_poll_response(res)
      JSON.parse(res.body)['chat']['events'].map { |event_params|
        Event.from_api(event_params)
      }.compact
    end
  end
end
