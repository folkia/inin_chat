window.InteractionWebTools ||= {}
window.InteractionWebTools.Chat ||= {}

class InteractionWebTools.Chat.Client
  stateEnum = {
    INITIAL: 0
    START_PENDING: 1,
    STARTED: 2,
    KILLED: 3
  }

  constructor: ->
    @state = stateEnum.INITIAL
    @queuedMessages = []
    @endpoint = '/interaction_web_tools/events'
    @chatUI = $('#chat-ui')
    console.log "Chat Client Instantiated"

  open: =>
    @chatUI.toggleClass('active')
    console.log "Chat Client Opened"

  close: ->
    @terminateChat()
    @chatUI.toggleClass('active')
    console.log "Chat Client Opened"

  send: (message) ->
    console.log "Chat Client wants to send message", message
    @startChat() unless @state == stateEnum.STARTED
    @sendMessage(message)

  startChat: ->
    return if @state == stateEnum.START_PENDING
    @state = stateEnum.START_PENDING
    @pollMessages()
    console.log "Chat Client Chat Start Peding"

  pollMessages: ->
    return if @state == stateEnum.KILLED
    console.log "Chat Client is polling for messages"
    $.get @endpoint, (data) =>
      @state = stateEnum.STARTED
      @dismissWelcome()
      @dequeueMessages()
      @renderMessages data.events

      $.each data.events, (index, event) =>
        if (event.type == 'participantStateChanged' &&
            event.state == 'disconnected' &&
            event.participant_type == 'WebUser')
          @state = stateEnum.KILLED

      setTimeout () =>
        @pollMessages()
      , 1000 if @state == stateEnum.STARTED || @state == stateEnum.START_PENDING

  sendMessage: (message) ->
    return unless message
    return @queueMessage(message) unless @state == stateEnum.STARTED

    $.post @endpoint, { event: { content: message } }, (data) =>
      @renderMessages data.events
      console.log "Chat Client sent message", message

  queueMessage: (message) ->
    @queuedMessages.push(message)
    console.log "Chat Client queued a message for sending", message

  dismissWelcome: ->
    $('.chat > .chat-body > .welcome').fadeOut();

  dequeueMessages: ->
    $.each @queuedMessages, (i,message) =>
      console.log "Chat Client dequeued a message for sending", message
      @sendMessage(message)
    @queuedMessages = []

  renderMessages: (messages) ->
    messages = $.grep messages, (el) -> el.type == 'text'
    return unless messages.length

    messagesDiv = @chatUI.find('.chat-messages')
    $.each messages, (index, message) =>
      message.content = message.content.replace(/(?:\r\n|\r|\n)/g, '<br />');
      @displayMessage message
    messagesDiv.scrollTop messagesDiv[0].scrollHeight

  displayMessage: (message) =>
    @chatUI.find('.chat-messages').append(
      "<div class='message-#{message.participant_type.toLowerCase()}'>
       #{message.content}
       </div>"
    )

  terminateChat: =>
    $.ajax
      url: @endpoint
      type: 'DELETE'
    console.log "Chat Terminated"

    @state = stateEnum.KILLED
    console.log "Chat Client Chat Terminated"
