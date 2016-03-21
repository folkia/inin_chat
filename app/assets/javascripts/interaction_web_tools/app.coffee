window.InteractionWebTools ||= {}
window.InteractionWebTools.chat = new Chat

$(document).on 'click', '.chat-start', ->
  InteractionWebTools.chat.init()

$(document).on 'click', '.chat-stop', ->
  InteractionWebTools.chat.stop()

$(document).on 'submit', 'form.chat-message-form', (e) ->
  e.preventDefault()
  input = $(@).find 'textarea[name=content]'
  InteractionWebTools.chat.sendMessage input.val()
  input.val ''
  false

$(document).on 'keyup', 'textarea.chat-message-input', (e) ->
  if (e.keyCode == 10 || e.keyCode == 13)
    if (e.shiftKey)
      # CR
      e.preventDefault()
    else
      $(@).parents('form').first().trigger('submit')

