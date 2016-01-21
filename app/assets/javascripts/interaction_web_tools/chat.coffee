# TODO: set content-type for requests
# TODO: refactor 'that' hack
# TODO: create helper for rendering chat partial

window.Chat = class Chat
  #@EVENTS_PATH: 'interaction_web_tools/events'
  @EVENTS_PATH: 'http://private-cf542-ininmessages.apiary-mock.com/events'
  @MESSAGES_DIV: '.chat-messages'

  constructor: ->

  receiveMessages: ->
    that = @
    $.get @constructor.EVENTS_PATH, (data) ->
      that.renderMessages data.events

  sendMessage: (message) ->
    that = @
    $.post @constructor.EVENTS_PATH, { event: { content: message } }, (data) ->
      that.renderMessages data.events

  renderMessages: (messages) ->
    messages = $.grep messages, (el) -> el.type == 'text'
    that = @
    $.each messages, (index, message) ->
      $(that.constructor.MESSAGES_DIV).append(
        "<div class='message-#{message.participant_type}'>
         #{message.participant_type}: #{message.content}
         </div>"
      )
