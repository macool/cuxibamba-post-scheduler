loadingIconSelector = ".icon.loading"
formatMdSelector = "input#post_format_md"
wrapperSelector = ".post-parsed-content-preview-wrapper"

class PostContentPreview
  constructor: (@value) ->
    @$wrapper = $(wrapperSelector)
    @performQuery()
    @loadingStatus(true)

  loadingStatus: (status) ->
    methodName = if status then "removeClass" else "addClass"
    $(loadingIconSelector)[methodName]("hidden")

  performQuery: ->
    $.post(@$wrapper.data("path"), value: @value, @gotResponse)

  gotResponse: (data) =>
    @loadingStatus(false)
    @$wrapper.find(".content").html(data)

lastValue = null

textareaUpdated = ->
  return unless $(formatMdSelector).is(":checked")
  newValue = lastValue != $.trim(@value)
  if newValue
    lastValue = $.trim(@value)
    new PostContentPreview @value

debouncedTextareaUpdated = debounce textareaUpdated, 500

formatMdChanged = ->
  methodName = if @checked then "show" else "hide"
  $(wrapperSelector)[methodName]()
  $("textarea#post_content").trigger "keyup"

$(document).on "keyup", "textarea#post_content", debouncedTextareaUpdated
$(document).on "change", formatMdSelector, formatMdChanged
$(document).on "turbolinks:load", ->
  $(formatMdSelector).trigger "change"
