module InteractionWebTools
  class EventsController < ApplicationController

    def load_chat
      session['interaction_web_tools'] ||= {}
      provider_id = session['interaction_web_tools']['provider_id']
      unless provider_id
        provider_id = client.start
        session['interaction_web_tools']['provider_id'] = provider_id
      end
      provider_id
    end

    def index
      provider_id = load_chat
      @events = client.poll(provider_id)
      unless @events
        session['interaction_web_tools']['provider_id'] = nil
        provider_id = load_chat
        @events = client.poll(provider_id)
      end
      @events
    end

    def create
      provider_id = load_chat
      @events = client.send_message(provider_id, params[:event][:content])
      render 'index'
    end

    private

    def client
      InteractionWebTools::IninChatAdapter.new
    end

    def event_params
      params.require(:event).permit(:content).symbolize_keys
    end
  end
end
