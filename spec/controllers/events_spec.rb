require 'rails_helper'

RSpec.describe IninChat::EventsController do
  before do
    let session_chat do
      {
        events: [
          {
            type: :text,
            sequence_number: 1,
            participant_type: :user,
            participant_id: SecureRandom.uuid,
            content: 'Hello'
          },
          {
            type: :text,
            sequence_number: 2,
            participant_type: :operator,
            participant_id: SecureRandom.uuid,
            content: 'Hello back'
          },
          {
            type: :text,
            sequence_number: 3,
            participant_type: :system,
            participant_id: SecureRandom.uuid,
            content: 'You have successfully logged in to the chat'
          }
        ]
      }
    end
    
    allow(session).to receive(:inin_chat) { session_chat  }
  end

  context '#index' do
    it "responds with session's messages" do
      get :index
      expect(response.body).to eq session_chat
    end
  end
end
