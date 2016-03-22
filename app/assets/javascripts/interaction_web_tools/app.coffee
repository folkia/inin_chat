window.InteractionWebTools ||= {}
window.InteractionWebTools.Chat ||= {}

jQuery ->
  @chatClient = new InteractionWebTools.Chat.Client
  InteractionWebTools.Chat.instance = @chatClient

  $(document).on 'click', '.chat > .controls > a.open', =>
    @chatClient.open()
    false

  $(document).on 'click', '.chat > .controls > a.close', =>
    @chatClient.close()
    false

  $(document).on 'submit', 'form.chat-message-form', (e) =>
    input = $(e.target).find('textarea[name=content]')
    @chatClient.send input.val()
    input.val ''
    false

  $(document).on 'keydown', 'textarea.chat-message-input', (e) ->
    if (e.keyCode == 10 || e.keyCode == 13)
      return true if (e.shiftKey)
      $(e.target).parents('form').first().trigger('submit')
      false

  $(document).on 'beforeunload', 'hmtl', (e) =>
    @chatClient.terminateChat()