window.InteractionWebTools ||= {}
window.InteractionWebTools.Chat ||= {}

class InteractionWebTools.Chat.Client
  stateEnum = {
    INITIAL: 0
    START_PENDING: 1,
    ACTIVE: 2,
    TERMINATED: 3
  }

  constructor: ->
    @state = stateEnum.INITIAL
    @queuedMessages = []
    @endpoint = '/interaction_web_tools/events'
    @chatUI = $('#chat-ui')
    if window.location.href.indexOf('debug=1') > -1
      @debug = true

  open: =>
    @chatUI.toggleClass('active')

  close: ->
    @terminateChat()
    @chatUI.toggleClass('active')

  send: (message) ->
    return if message == ""
    @startChat() unless @state == stateEnum.ACTIVE
    @sendMessage(message)
    @displayIndicator("webuser")

  startChat: (showIndicator) ->
    return if @state == stateEnum.START_PENDING
    @state = stateEnum.START_PENDING
    @displayIndicator("system") if showIndicator
    @pollMessages()

  pollMessages: ->
    return if @state == stateEnum.TERMINATED
    $.get @endpoint, (data) =>
      eventsReceived = data.events

      hasTextMessages = (
        $.grep eventsReceived, (el) -> el.type == 'text'
      ).length > 0
      hasUserDisconnectedEvent = (
        $.grep eventsReceived,
          (el) -> el.type == 'participantStateChanged' &&
            el.state == 'disconnected' &&
            el.participant_type == 'WebUser'
      ).length > 0

      @renderMessages eventsReceived

      if hasTextMessages && !hasUserDisconnectedEvent
        @state = stateEnum.ACTIVE
        @dismissWelcome()
        @dequeueMessages()

      @state = stateEnum.TERMINATED if hasUserDisconnectedEvent

      setTimeout () =>
        @pollMessages()
      , 1000 if @state == stateEnum.ACTIVE || @state == stateEnum.START_PENDING

  sendMessage: (message) ->
    return unless message
    return @queueMessage(message) unless @state == stateEnum.ACTIVE

    $.post @endpoint, { event: { content: message } }, (data) =>
      @renderMessages data.events

  queueMessage: (message) ->
    console.log "add " + message + " to " + @queuedMessages if @debug
    @queuedMessages.push(message)

  dismissWelcome: ->
    $('.chat > .chat-body > .welcome').fadeOut()

  dequeueMessages: ->
    console.log "dequeue messages " + @queuedMessages if @debug
    $.each @queuedMessages, (i,message) =>
      @sendMessage(message)
    @queuedMessages = []

  renderMessages: (messages) ->
    console.log "messages recieved for render", messages if @debug
    typing = $.grep(
      messages,
      (el) -> el.type == 'typingIndicator' && el.content == true
    )
    @displayIndicator("agent") if typing.length

    messages = $.grep messages, (el) -> el.type == 'text'
    return unless messages.length

    $.each messages, (index, message) =>
      message.content =
        message.content.replace(/(?:\r\n|\r|\n)/g, '<br />')
      @displayMessage message


  displayMessage: (message) =>
    type = message.participant_type.toLowerCase()
    @hideIndicator(type)
    @chatUI.find('.chat-messages').append(
      "<div class='message-#{type}'>
       #{message.content}
       </div>"
    )
    @autoScroll()

  terminateChat: =>
    if @state == stateEnum.ACTIVE
      $.ajax
        url: @endpoint
        type: 'DELETE'
    @state = stateEnum.TERMINATED

  displayIndicator: (type) =>
    indicator = @chatUI.find(".indicator").first().clone()
    wrap =
      $("<div class='pending message-#{type}'></div>")
      .append(indicator.show())
    @hideIndicator(type)
    @chatUI.find('.chat-messages').append(wrap)
    @autoScroll()

  hideIndicator: (type) =>
    @chatUI.find(".message-#{type}.pending").remove()

  autoScroll: =>
    scrollView = @chatUI.find('.chat-body')
    scrollView.scrollTop(scrollView[0].scrollHeight)