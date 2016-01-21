require 'rails_helper'

describe InteractiveWebTools::EventsController do
  routes { InteractiveWebTools::Engine.routes }

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
    session[:interactive_web_tools] = session_chat
  end

  context '#index' do
    it "responds with session's messages" do
      get :index, format: :json
      chat_json = { events: session_chat[:events].map(&:marshal_dump) }.to_json
      expect(response.body).to eq chat_json
    end
  end
  
  context '#create' do
    it 'responds with session messages plus new message' do
      new_message_params = { content: 'foo' }
      chat_json = {
        events: session_chat[:events]
          .dup
          .push(OpenStruct.new(new_message_params))
          .map(&:marshal_dump)
      }.to_json

      post :create, event: new_message_params, format: :json
      expect(response.body).to eq chat_json
    end
  end
end
