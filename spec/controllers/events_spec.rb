require 'rails_helper'

describe IninChat::EventsController do
  routes { IninChat::Engine.routes }

  let :session_chat do
    {
      events: [
        OpenStruct.new(
          type: :text,
          sequence_number: 1,
          participant_type: :user,
          participant_id: SecureRandom.uuid,
          content: 'Hello'
        ),
        OpenStruct.new(
          type: :text,
          sequence_number: 2,
          participant_type: :operator,
          participant_id: SecureRandom.uuid,
          content: 'Hello back'
        ),
        OpenStruct.new(
          type: :text,
          sequence_number: 3,
          participant_type: :system,
          participant_id: SecureRandom.uuid,
          content: 'You have successfully logged in to the chat'
        )
      ]
    }
  end
    
  before do
    session[:inin_chat] = session_chat
  end

  context '#index' do
    it "responds with session's messages" do
      get :index, format: :json
      expect(response.body).to eq session_chat.to_json
    end
  end
  
  context '#create' do
    let(:new_message) { { content: 'foo' } }
    let (:new_session_chat) { session_chat[:events] << new_message  }

    it 'responds with session messages plus new message' do
      post :create, event: new_message, format: :json
      expect(response.body).to eq new_session_chat.to_json
    end
  end
end
