###
# Undersky Definition
###

class Undersky
  undersky = this
  $w = $(window)
  $d = $(document)

  class Growl
    top = ->
      $('.alert-message.growl').size() * 34 + 40;

    @show: (text, level) ->
      level ||= 'info'
      growl = $('<div class="alert-message growl ' + level + '">' + text + '</div>')
      growl.css('top', top() + 'px')
      $(document.body).append(growl)
      growl.alert().hide().slideDown()
      setTimeout(->
        growl.slideUp ->
          growl.remove()
      , 3000)

  class MediaGrid
    self = this

    @columns: ->
      $('.media-grid a')

    @toggle: (e) ->
      return if e.hasModifierKey()
      e && e.preventDefault()
      panels = $('.modal.media-panel')
      panels.filter('.show').hide()
      columns = self.columns()
      column = $(this)
      id = column.attr('data-id')
      actived = column.hasClass('actived')
      columns.filter('.actived, .focused').removeClass('actived').removeClass('focused')
      column.addClass('focused')
      unless actived
        column.addClass('actived')
        panels.filter('[data-id=' + id + ']').show()
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
        $w.scrollTop(column.offset().top - 65)

    @next: (e) ->
      columns = self.columns()
      column = columns.filter('.focused')
      if column.size()
        column = column.parent().next().find('a').first()
      else
        column = columns.first()
      if column.size()
        self.toggle.call(column, e)
        $w.scrollTop(column.offset().top - 65)

    @resize: ->
      $('.modal.media-panel.show').css('height', $w.height() - 75)

    do ->
      $w.resize self.resize
      $d.delegate '.media-grid a', 'click', self.toggle
      $d.keydown self.action

new Undersky
