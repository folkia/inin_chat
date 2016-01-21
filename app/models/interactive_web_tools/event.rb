module InteractiveWebTools
  class Event
    attr_reader :type,
                :sequence_number,
                :participant_type,
                :participant_id
    
    attr_accessor :content

    def initialize(content:)
      @content = content
    end
  end
end
