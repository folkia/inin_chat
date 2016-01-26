module InteractionWebTools
  class EventsController < ApplicationController
    def index
      provider_id = load_chat
      @events = poll_reposnse.events
    end

    def create
      provider_id = load_chat
      @events = client.send_message(provider_id, params[:event][:content])
      render 'index'
    end

    private

    def poll_events(provider_id, retry_count = 5)
      return nil if retry_count < 1
      poll_response = client.poll(provider_id)
      if poll_response.status != 'success' || !poll_response.events
        session['interaction_web_tools']['provider_id'] = nil
        poll_events(provider_id, retry_count--)
      end
    end

    def load_chat
      session['interaction_web_tools'] ||= {}
      provider_id = session['interaction_web_tools']['provider_id']
      unless provider_id
        provider_id = client.start
        session['interaction_web_tools']['provider_id'] = provider_id
      end
      provider_id
    end

    def client
      InteractionWebTools::IninChatAdapter.new
    end

    def event_params
      params.require(:event).permit(:content).symbolize_keys
    end
  end
end
