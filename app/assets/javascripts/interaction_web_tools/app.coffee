window.InteractionWebTools ||= {}
window.InteractionWebTools.chat = new Chat

$(document).on 'click', '.chat-start', ->
  InteractionWebTools.chat.init()

$(document).on 'click', '.chat-stop', ->
  InteractionWebTools.chat.stop()

$(document).on 'submit', 'form.chat-message-form', (e) ->
  e.preventDefault()
  input = $(@).find 'input[name=content]'
  InteractionWebTools.chat.sendMessage input.val()
  input.val ''
  false
