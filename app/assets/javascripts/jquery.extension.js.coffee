###
# jQuery Extension
###

# Saved default show & hide
$.fn.extend
  __show: $.fn.show,
  __hide: $.fn.hide

# Replace show & hide to bootstrap
$.fn.extend
  show: ->
    this.addClass('show').removeClass('hide')
  hide: ->
    this.addClass('hide').removeClass('show')
  intText: ->
    parseInt(this.text())
  incText: ->
    this.text(this.intText() + 1)
  decText: ->
    this.text(this.intText() - 1)
  isInput: ->
    this.is('input') || this.is('textarea') || this.is('select')
  enableElement: ->
    this.attr('disabled', null)
    this.unbind('click.railsDisable')
  disableElement: ->
    this.attr('disabled', 'disabled')
    this.bind('click.railsDisable', (e) ->
      $.rails.stopEverything(e))
  bindAjaxHandler: (handlers) ->
    for eventName, handler of handlers
      this.live 'ajax:' + eventName, handler
    this

# Add methods to Event
$.extend $.Event.prototype, hasModifierKey: ->
  return this.altKey || this.ctlrKey || this.metaKey || this.shiftKey

