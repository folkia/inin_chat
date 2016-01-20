module IninChat
  class EventsController < ApplicationController
    def index
      render json: session[:inin_chat]
    end

    def create
    end
  end
end
