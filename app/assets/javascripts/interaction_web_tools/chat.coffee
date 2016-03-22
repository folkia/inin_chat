window.Chat = class Chat
  @EVENTS_PATH: '/interaction_web_tools/events'
  @CHAT_BODY: '.chat-body'
  @CHAT_CLOSE: '.chat-stop'
  @MESSAGES_DIV: '.chat-messages'

  constructor: ->
    @started = false

  init: ->
    @onChatDialogInit()

  stop: ->
    @terminateChat()

  # TODO: Extract to separate messaage class
  systemMessage: (content) ->
    {
      type: 'text',
      participant_type : 'System',
      content: content
    }

  onChatDialogInit: ->
    $(@constructor.CHAT_BODY).show()
    $(@constructor.CHAT_CLOSE).show()

  pollMessages: ->
    $.get Chat.EVENTS_PATH, (data) ->
      InteractionWebTools.chat.renderMessages data.events

      $.each data.events, (index, event) ->
        if (event.type == 'participantStateChanged' and
            event.state == 'disconnected' and
            event.participant_type == 'WebUser')
          return InteractionWebTools.chat.started = false

      if InteractionWebTools.chat.started
        setTimeout InteractionWebTools.chat.pollMessages, 1000

  sendMessage: (message) ->
    unless @started
      @pollMessages()
      @started = true
    return false unless message
    that = @
    $.post @constructor.EVENTS_PATH, { event: { content: message } }, (data) ->
      that.renderMessages data.events

  renderMessages: (messages) ->
    messages = $.grep messages, (el) -> el.type == 'text'
    messagesDiv = $(@constructor.MESSAGES_DIV)
    $.each messages, (index, message) ->
      message.content = message.content.replace(/(?:\r\n|\r|\n)/g, '<br />');
      InteractionWebTools.chat.displayMessage message
    messagesDiv.scrollTop messagesDiv[0].scrollHeight if messages.length

  displayMessage: (message) ->
    $(@constructor.MESSAGES_DIV).append(
      "<div class='message-#{message.participant_type.toLowerCase()}'>
       #{message.content}
       </div>"
    )

  terminateChat: ->
    InteractionWebTools.chat.started = false
    $(@constructor.CHAT_BODY).hide()
    $(@constructor.CHAT_CLOSE).hide()
    $.ajax
      url:  @constructor.EVENTS_PATH
      type: 'DELETE'
      success: (result) ->
        return

window.onbeforeunload = ->
  Chat.prototype.terminateChat()
  return null
