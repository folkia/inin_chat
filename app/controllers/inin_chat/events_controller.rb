module IninChat
  class EventsController < ApplicationController
    def index
      @events = session[:inin_chat]
    end

    def create
      @events = session[:inin_chat]
      @events[:events] << Event.new(event_params)
      render 'index'
    end

    private

    def event_params
      params.require(:event).permit(:content).symbolize_keys
    end
  end
end
