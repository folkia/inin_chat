require 'rails_helper'

describe InteractionWebTools::ChatResponse do
  let(:chat_id){
    "2fbd90a0-4285-4dff-8da2-d5ffc25d5014"
  }
  let(:test_message) { FFaker::Lorem.phrase }
  let(:successful_start_response_body){
    {
      "chat": {
        "pollWaitSuggestion": 2000,
        "cfgVer": 1,
        "participantID": chat_id,
        "dateFormat": "yyyy-MM-dd",
        "timeFormat": "HH:mm:ss",
        "chatID": chat_id,
        "status": {
          "type": "success"
        }
      }
    }
  }
  let(:failure_start_response_body){
    {
      "chat": {
        "pollWaitSuggestion": 2000,
        "cfgVer": 1,
        "participantID": chat_id,
        "dateFormat": "yyyy-MM-dd",
        "timeFormat": "HH:mm:ss",
        "chatID": chat_id,
        "status": {
          "type": "failure"
        }
      }
    }
  }
  let(:successful_poll_response_example_1_body){
    {
      "chat": {
        "pollWaitSuggestion": 2000,
        "cfgVer": 1,
        "status": {
          "type": "success"
        },
        "events": [
          {
            "type": "text",
            "participantID": "00000-0000-0000-0000-00000",
            "sequenceNumber": 1,
            "conversationSequenceNumber": 0,
            "contentType": "text/plain",
            "value": test_message,
            "displayName": "Customer",
            "participantType": "System"
          }
        ]
      }
    }
  }
  let(:successful_start_response){
    InteractionWebTools::ChatResponse.parse(successful_start_response_body.to_json)
  }
  let(:failure_start_response){
    InteractionWebTools::ChatResponse.parse(failure_start_response_body.to_json)
  }
  let(:successful_example_1_poll_response){
    InteractionWebTools::ChatResponse.parse(successful_poll_response_example_1_body.to_json)
  }

  context 'start' do
    it 'responds to chat_id' do
      expect(successful_start_response.chat_id).to eq chat_id
    end

    it 'responds to status successfully' do
      expect(successful_start_response.status[:type]).to eq "success"
    end
  end

  context '#success?' do
    it 'responds true on successful status' do
      expect(successful_start_response.success?).to be true
    end
    it 'responds false on failure status' do
      expect(failure_start_response.success?).to be false
    end
  end

  context '#failure?' do
    it 'responds true on successful status' do
      expect(successful_start_response.failure?).to be false
    end
    it 'responds false on failure status' do
      expect(failure_start_response.failure?).to be true
    end
  end

  context 'events' do
    it 'parses events from poll' do
      expect(successful_example_1_poll_response.events).not_to be_empty
    end

    it 'parses includes correct text in parsed event' do
      expect(successful_example_1_poll_response.events.map(&:content)).to include test_message
    end
  end
end
