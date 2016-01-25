require 'rails_helper'

describe InteractionWebTools::EventsController do
  routes { InteractionWebTools::Engine.routes }

  let(:chat_id) { "8026ac6e-2bae-488b-810e-de776e83096a" }
  let(:test_message_for_sending) { FFaker::Lorem.phrase }
  let(:test_message_for_polling) { FFaker::Lorem.phrase }
  let(:server_host) { URI(InteractionWebTools.config.inin_server).host }
  before do
    @start_chat_body =
      {
        "chat": {
          "pollWaitSuggestion": 2000,
          "cfgVer": 1,
          "participantID": chat_id,
          "dateFormat": "yyyy-MM-dd",
          "timeFormat": "HH:mm:ss",
          "chatID": "2fbd90a0-4285-4dff-8da2-d5ffc25d5014",
          "status": {
            "type": "success"
          }
        }
      }

    @poll_example_body =
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
              "value": test_message_for_polling,
              "displayName": "Customer",
              "participantType": "System"
            }
          ]
        }
      }

    @send_example_body =
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
              "participantID": "b6c0849e-f0d6-4516-9970-3ce44a951cde",
              "sequenceNumber": 2,
              "conversationSequenceNumber": 0,
              "contentType": "text/plain",
              "value": test_message_for_sending,
              "displayName": "Customer",
              "participantType": "WebUser"
            }
          ]
        }
      }

    WebMock.stub_request(:post, /.*#{Regexp.quote("/websvcs/chat/start")}/).
      with(:body => "{\"target\":\"Frogtail Labb\",\"participant\":{\"name\":\"Customer\",\"credentials\":\"\"},\"supportedContentTypes\":\"text/plain\",\"emailAddress\":\"\",\"targetType\":\"Workgroup\",\"customInfo\":\"Frogtail Chat test annotation!|phone=\",\"language\":\"sv\",\"transcriptRequired\":false,\"clientToken\":\"deprecated\"}",
           :headers => { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type' => ['application/json', 'application/json'], 'Host' => server_host, 'User-Agent' => 'Ruby' }).
      to_return(:status => 200, :body => @start_chat_body.to_json, :headers => {})

    WebMock.stub_request(:get, /.*#{Regexp.quote("/websvcs/chat/poll/#{chat_id}")}/).
      with(:headers => { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => server_host, 'User-Agent' => 'Ruby' }).
      to_return(:status => 200, :body => @poll_example_body.to_json, :headers => {})

    WebMock.stub_request(:get, /.*#{Regexp.quote("/websvcs/chat/sendMessage/#{chat_id}")}/).
      with(:body => "{\"message\":\"#{test_message_for_sending}\",\"contentType\":\"text/plain\"}",
           :headers => { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type' => ['application/json', 'application/json'], 'Host' => server_host, 'User-Agent' => 'Ruby' }).
      to_return(:status => 200, :body => @send_example_body.to_json, :headers => {})
  end

  context '#index' do
    it "responds with session's messages" do
      get :index, format: :json
      received_message_content = JSON.parse(response.body)['events'][0]['content']
      expect(received_message_content).to eq test_message_for_polling
    end
  end

  context '#create' do
    it 'responds with session messages plus new message' do
      new_message_params = { content: test_message }
      post :create, event: new_message_params, format: :json
      events_from_response = JSON.parse(response.body)['events']
      expect(events_from_response.any? { |event| event['content'] == test_message }).to be true
    end
  end
end
