currentIntroSwitchable = null

class MainIntroSwitchable
  timing: 5*1000
  nextSwitchable: 0

  constructor: (@$selector) ->
    @loadSwitchables()
    @setTimer()

  loadSwitchables: ->
    @switchables = @$selector.data("switchables")

  setTimer: ->
    @currentTimeout = setTimeout @performSwitch, @timing

  performSwitch: =>
    nextSwitchable = @switchables[@nextSwitchable]
    $switchable = @$selector.find(".switchable")
    $switchable.animate opacity: 0, ->
      $switchable.text(nextSwitchable)
                 .animate(opacity: 1)
    @nextSwitchable += 1
    if @nextSwitchable >= @switchables.length
      @nextSwitchable = 0
    @setTimer()

  killTimer: ->
    if @currentTimeout
      clearTimeout @currentTimeout

$(document).on "turbolinks:load", ->
  $selector = $(".main-intro")
  if $selector.length > 0
    currentIntroSwitchable = new MainIntroSwitchable($selector)

$(document).on "turbolinks:before-visit", ->
  if currentIntroSwitchable
    currentIntroSwitchable.killTimer()
