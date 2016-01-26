require "interaction_web_tools/engine"

module InteractionWebTools
  DefaultConfig =
    Struct.new(
      :inin_server,
      :chat_target,
      :chat_additional_information) do
      def initialize
        self.inin_server = :inin_server
        self.chat_additional_information = :chat_additional_information
        self.chat_target = :chat_target
      end
    end

  def self.configure
    @config = DefaultConfig.new
    yield(@config) if block_given?
    @config
  end

  def self.config
    @config || configure
  end
end
