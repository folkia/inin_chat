module InteractiveWebTools
  class EventsController < ApplicationController
    def index
      @events = session[:interactive_web_tools]
    end

    def create
      @events = session[:interactive_web_tools]
      @events[:events] << Event.new(event_params)
      render 'index'
    end

    private

    def event_params
      params.require(:event).permit(:content).symbolize_keys
    end
  end
end
