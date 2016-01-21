window.InteractionWebTools ||= {}
window.InteractionWebTools.chat = new Chat

$ ->
  InteractionWebTools.chat.receiveMessages()

$(document).on 'submit', 'form.chat-message-form', (e) ->
  e.preventDefault()
  input = $(@).find 'input[name=content]'
  InteractionWebTools.chat.sendMessage input.val()
  input.val ''
  false
