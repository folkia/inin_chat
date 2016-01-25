window.Chat = class Chat
  @EVENTS_PATH: 'interaction_web_tools/events'
  @CHAT_BODY: '.chat-body'
  @MESSAGES_DIV: '.chat-messages'

  constructor: ->
    @started = false

  init: ->
    @started = true
    @pollMessages()

  stop: ->
    @started = false
    $(@constructor.CHAT_BODY).hide()

  pollMessages: ->
    $.get Chat.EVENTS_PATH, (data) ->
      InteractionWebTools.chat.renderMessages data.events
      if InteractionWebTools.chat.started
        setTimeout InteractionWebTools.chat.pollMessages, 1000

  sendMessage: (message) ->
    return false unless message
    that = @
    $.post @constructor.EVENTS_PATH, { event: { content: message } }, (data) ->
      that.renderMessages data.events

  renderMessages: (messages) ->
    return false unless @started
    $(@constructor.CHAT_BODY).show()
    messages = $.grep messages, (el) -> el.type == 'text'
    messagesDiv = $(@constructor.MESSAGES_DIV)
    $.each messages, (index, message) ->
      messagesDiv.append(
        "<div class='message-#{message.participant_type}'>
         #{message.participant_type}: #{message.content}
         </div>"
      )
    messagesDiv.scrollTop messagesDiv[0].scrollHeight
