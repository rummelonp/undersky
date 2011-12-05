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

  class Search
    self = this

    @submit: (e) ->
      e && e.preventDefault()
      form = $(this);
      name = form.find('[name="name"]').attr('value')
      url = '/search'
      if name
        url += '/' + name
      location.href = url

    do ->
      $('form[action="/search"]').live 'submit', self.submit

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
      column.addClass('focused').focus()
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
      return if $(e.target).isInput()
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
        container.before('<div class="count">' + data.length + ' likes</div>')
        for u in data
          username = $('<span class="username"></span>')
          username.append('<a href="/users/' + u.id + '">' + u.username + '</a>');
          container.append(username)
          container.append(', ')
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
        container.before('<div class="count">' + data.length + ' comments</div>')
        for c in data
          comment = $('<div class="comment"></div>')
          comment.append('<a href="/users/' + c.from.id + '">' + c.from.username + '</a>');
          comment.append('<span class="text">' + c.text + '</span>')
          container.append(comment)
      error: (e, data) ->
        self = $(this)
        spinner = self.data('spinner')
        spinner.hide()
        Growl.show('comments load failed', 'error')

    do ->
      $('.comments-load a').bindAjaxHandler self.commentsHandler

  class Relationships
    self = this

    @relationshipsHandler:
      beforeSend: (e) ->
        $(this).disableElement()
      success: (e, data) ->
        status = $(this).parents('.outgoing_status')
        status.removeClass().addClass('outgoing_status').addClass(data.outgoing_status)
      complete: (e, data) ->
        $(this).enableElement()

    @followHandler:
      error: (e, data) ->
        Growl.show('follow request failed', 'error')

    @unfollowHandler:
      error: (e, data) ->
        Growl.show('unfollow request failed', 'error')

    do ->
      $('.relationship-button a').bindAjaxHandler self.relationshipsHandler
      $('.relationship-button.follow a').bindAjaxHandler self.followHandler
      $('.relationship-button.unfollow a').bindAjaxHandler self.unfollowHandler

new Undersky
