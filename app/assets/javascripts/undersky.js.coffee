###
# Undersky Definition
###

class Undersky
  undersky = this
  $w = $(window)
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
      self.resize()

    @action: (e) ->
      switch e.which
        when 37, 75 # ←, k
          self.prev(e)
        when 39, 74 # →, j
          self.next(e)

    @prev: (e) ->
      columns = self.columns()
      column = columns.filter('.focused')
      if column.size()
        column = column.parent().prev().find('a').first()
      if column.size()
        self.toggle.call(column, e)

    @next: (e) ->
      columns = self.columns()
      column = columns.filter('.focused')
      if column.size()
        column = column.parent().next().find('a').first()
      else
        column = columns.first()
      if column.size()
        self.toggle.call(column, e)

    @resize: ->
      $('.modal.media-panel.show').css('height', $w.height() - 75)

    do ->
      $w.resize self.resize
      $d.delegate '.media-grid a', 'click', self.toggle
      $d.keydown self.action

new Undersky
