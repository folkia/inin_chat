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
      @state = stateEnum.ACTIVE
      @dismissWelcome()
      @dequeueMessages()
      @renderMessages data.events

      $.each data.events, (index, event) =>
        if (event.type == 'participantStateChanged' &&
            event.state == 'disconnected' &&
            event.participant_type == 'WebUser')
          @state = stateEnum.TERMINATED

      setTimeout () =>
        @pollMessages()
      , 1000 if @state == stateEnum.ACTIVE || @state == stateEnum.START_PENDING

  sendMessage: (message) ->
    return unless message
    return @queueMessage(message) unless @state == stateEnum.ACTIVE

    $.post @endpoint, { event: { content: message } }, (data) =>
      @renderMessages data.events

  queueMessage: (message) ->
    @queuedMessages.push(message)

  dismissWelcome: ->
    $('.chat > .chat-body > .welcome').fadeOut();

  dequeueMessages: ->
    $.each @queuedMessages, (i,message) =>
      @sendMessage(message)
    @queuedMessages = []

  renderMessages: (messages) ->
    console.log "messages recieved for render", messages
    typing = $.grep messages, (el) -> el.type == 'typingIndicator' && el.content == true
    @displayIndicator("agent") if typing.length

    messages = $.grep messages, (el) -> el.type == 'text'
    return unless messages.length

    $.each messages, (index, message) =>
      message.content = message.content.replace(/(?:\r\n|\r|\n)/g, '<br />');
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
    $.ajax
      url: @endpoint
      type: 'DELETE'
    @state = stateEnum.TERMINATED

  displayIndicator: (type) =>
    indicator = @chatUI.find(".indicator").first().clone()
    wrap = $("<div class='pending message-#{type}'></div>").append(indicator.show())
    @hideIndicator(type)
    @chatUI.find('.chat-messages').append(wrap)
    @autoScroll()

  hideIndicator: (type) =>
    @chatUI.find(".message-#{type}.pending").remove()

  autoScroll: =>
    scrollView = @chatUI.find('.chat-body')
    scrollView.scrollTop(scrollView[0].scrollHeight)