###
# Undersky Definition
###

class Undersky
  undersky = this
  $d = $(document)

  class MediaGrid
    self = this

    @columns: ->
      $('.media-grid a')

    @toggle: (e) ->
      return if e.hasModifierKey()
      e && e.preventDefault()
      columns = self.columns()
      column = $(this)
      panels = $('.modal.media-panel').hide()
      id = column.attr('data-id')
      if column.hasClass('actived')
        columns.removeClass('actived').removeClass('focused')
      else
        columns.removeClass('actived').removeClass('focused')
        column.addClass('actived')
        panels.filter('[data-id=' + id + ']').show()
      column.addClass('focused')

    do ->
      $d.delegate '.media-grid a', 'click', self.toggle

new Undersky
