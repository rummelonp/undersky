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

  class Spinner
    constructor: (element) ->
      @element = element
      @spinner = $('<div class="spinner"><img src="/assets/spinner.gif"></div>')

    show: ->
      @spinner.css
        width: @element.width(),
        height: @element.height()
      @element.before(@spinner)
      @element.hide()
      @spinner.show()

    hide: ->
      @spinner.hide()
      @element.show()

    remove: ->
      @element.remove()
      @spinner.remove()

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

    @close: (e) ->
      e && e.preventDefault()
      columns = self.columns()
      columns.filter('.actived').removeClass('actived')
      panels = $('.modal.media-panel')
      panels.filter('.show').hide()

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
      $d.delegate '.media-grid.photos a', 'click', self.toggle
      $d.delegate '.modal.media-panel .close', 'click', self.close
      $d.keydown self.action

  class Likes
    self = this

    @likesHandler:
      beforeSend: (e) ->
        self = $(this)
        spinner = new Spinner self
        spinner.show()
        self.data('spinner', spinner)
      success: (e, data) ->
        self = $(this)
        container = self.parents('.likes').find('.likes-data')
        spinner = self.data('spinner')
        spinner.remove()
        for u in data
          container.append('<span class="username"><a href="/users/' + u.id + '">' + u.username + "</a></span>, ")
      error: (e, data) ->
        self = $(this)
        spinner = self.data('spinner')
        spinner.hide()
        Growl.show('likes load failed', 'error')

    do ->
      $('.likes-load a').bindAjaxHandler self.likesHandler

  class Comments
    self = this

    @commentsHandler:
      beforeSend: (e) ->
        self = $(this)
        spinner = new Spinner self
        spinner.show()
        self.data('spinner', spinner)
      success: (e, data) ->
        self = $(this)
        container = self.parents('.comments').find('.comments-data')
        container.children().remove()
        spinner = self.data('spinner')
        spinner.remove()
        for c in data
          container.append('<div class="comment"><a href="/users/' + c.from.id + '">' + c.from.username + '</a><span class="text">' + c.text + '</span>')
      error: (e, data) ->
        self = $(this)
        spinner = self.data('spinner')
        spinner.hide()
        Growl.show('comments load failed', 'error')

    do ->
      $('.comments-load a').bindAjaxHandler self.commentsHandler

new Undersky
