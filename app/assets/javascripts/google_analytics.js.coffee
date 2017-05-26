$(document).on 'turbolinks:load', (event) ->
  if typeof ga is 'function'
    originalEvent = event.originalEvent
    ga('set', 'location', originalEvent.data.url)
    ga('send', 'pageview')
