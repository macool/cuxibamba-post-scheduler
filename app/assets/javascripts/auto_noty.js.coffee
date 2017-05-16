$(document).on "turbolinks:load", ->
  $(".auto-noty .flash-message").each () ->
    $this = $(this)
    noty = new Noty(
      closeWith: ['click', 'button']
      text: $this.html()
      type: $this.data("kind")
    )
    $this.remove()
    noty.show()

$(document).on "turbolinks:before-visit", ->
  Noty.closeAll()
  true
