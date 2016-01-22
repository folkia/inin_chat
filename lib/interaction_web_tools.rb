require "interaction_web_tools/engine"

module InteractionWebTools
  DefaultConfig = Struct.new(:inin_server) do
    def initialize
      self.inin_server = :inin_server
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
