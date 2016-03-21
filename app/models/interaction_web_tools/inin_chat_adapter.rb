module InteractionWebTools
  class IninChatAdapter
    def self.default_config
      {
        locale: 'en',
        chat_info: chat_initiation_payload,
        target: InteractionWebTools.config.chat_target
      }
    end

    def self.chat_initiation_payload
      InteractionWebTools.config.chat_additional_information.call
    end

    def start(opts)
      opts ||= {}
      config = self.class.default_config.merge opts
      dict = {
        "target" => config[:target],
        "participant" => {
          "name" => "Customer",
          "credentials" => ""
        },
        "supportedContentTypes" => "text/plain",
        "emailAddress" => "",
        "targetType" => "Workgroup",
        "customInfo" => config[:chat_info],
        "language" => config[:locale],
        "transcriptRequired" => false,
        "clientToken" => "deprecated"
      }

      res = make_post(
        URI("#{server}/chat/start"),
        dict
      )

      res.body
    end

    def poll(id)
      begin
        uri = URI("#{server}/chat/poll/#{id}")

        http = Net::HTTP.new(uri.host, uri.port)
        req = Net::HTTP::Get.new(uri)
        res = http.request(req)

        res.body
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
        res.body
      end
    end

    def exit_chat(id)
      begin
        res = make_post(
            URI("#{server}/chat/exit/#{id}"), {}
        )
        res.body
      end
    end

    private

    def server
      InteractionWebTools.config.inin_server
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
  end
end
