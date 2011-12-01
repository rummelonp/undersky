###
# jQuery Extension
###

# Saved default show & hide
$.extend $.fn,
  __show: $.fn.show,
  __hide: $.fn.hide

# Replace show & hide to bootstrap
$.extend $.fn,
  show: ->
    $(this).addClass('show').removeClass('hide')
  hide: ->
    $(this).addClass('hide').removeClass('show')

# Add methods to Event
$.extend $.Event.prototype, hasModifierKey: ->
  return this.altKey || this.ctlrKey || this.metaKey || this.shiftKey

