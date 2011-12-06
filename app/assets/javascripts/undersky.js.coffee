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

    @likesStatusHandler:
      beforeSend: (e) ->
        $(this).disableElement()
      complete: (e, data) ->
        $(this).enableElement()

    @likeHandler:
      success: (e, data) ->
        status = $(this).parents('.likes')
        status.removeClass('unlike').addClass('like')
      error: (e, data) ->
        Growl.show('like failed', 'error')

    @unlikeHandler:
      success: (e, data) ->
        status = $(this).parents('.likes')
        status.removeClass('like').addClass('unlike')
      error: (e, data) ->
        Growl.show('unlike failed', 'error')

    do ->
      $('.likes-load-link a').bindAjaxHandler self.likesHandler
      $('.likes-button a').bindAjaxHandler self.likesStatusHandler
      $('.likes-button.like a').bindAjaxHandler self.likeHandler
      $('.likes-button.unlike a').bindAjaxHandler self.unlikeHandler

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
          comment.append('<span class="username"><a href="/users/' + c.from.id + '">' + c.from.username + '</a></span>');
          comment.append('<span class="text">' + c.text + '</span>')
          container.append(comment)
      error: (e, data) ->
        self = $(this)
        spinner = self.data('spinner')
        spinner.hide()
        Growl.show('comments load failed', 'error')

    do ->
      $('.comments-load-link a').bindAjaxHandler self.commentsHandler

    class CreateComment
      self = this

      @show: (e) ->
        e && e.preventDefault()
        self = $(this)
        panel = self.parents('.modal.media-panel')
        caption_data = panel.find('.caption')
        comments_data = panel.find('.comments-data')
        container = $('<div class="modal create-comment"></div>')
        form = $('<form action="' + self.attr('href') + '" method="post" data-remote="true"></form>')
        header = $('<div class="modal-header">comment</div>')
        body = $('<div class="modal-body"><textarea name="text" rows="4" cols="50" required="required"></textarea></div>')
        footer = $('<div class="modal-footer"></div>')
        footer.append('<div class="pull-left"><input class="btn primary" name="commit" type="submit" value="comment" disabled="disabled" /></div>')
        footer.append('<div class="pull-left"><input class="btn" name="cancel" type="reset" value="cancel" /></div>')
        form.append(header, body, footer)
        if caption_data.size() > 0
          caption = $('<div class="modal-footer"></div>')
          caption.append(caption_data.clone())
          form.append(caption)
        if comments_data.size() > 0
          comments = $('<div class="modal-footer"></div>')
          comments.append(comments_data.clone())
          form.append(comments)
        container.append(form)
        container.modal(show: true)
        container.bind('hidden', -> container.remove())
        container.find('textarea').focus()

      @reply: (e) ->
        e && e.preventDefault()
        self = $(this)
        username = '@' + $(this).text() + ' ';
        textarea = self.parents('.modal.create-comment').find('textarea')
        textarea.focus()
        textarea.val(username + textarea.val().replace(username, ''))

      @validate: (e) ->
        self = $(this)
        commit = $(this).parents('.modal.create-comment').find('[name="commit"]')
        if self.val().length > 0
          commit.enableElement()
        else
          commit.disableElement()

      @hide: (e) ->
        e && e.preventDefault()
        $(this).parents('.modal.create-comment').modal(show: false)

      @handler:
        beforeSend: (e) ->
          self = $(this)
          self.find('input, textarea').each(-> $(this).disableElement())
        success: (e, data) ->
          $(this).parents('.modal.create-comment').modal(show: false)
        error: (e, ddata) ->
          Growl.show('comment request failed', 'error')
        complete: (e, data) ->
          self = $(this)
          self.find('input, textarea').each(-> $(this).enableElement())

      do ->
        $d.delegate '.comments-button.create-comment a', 'click', self.show
        $d.delegate '.modal.create-comment .username a', 'click', self.reply
        $d.delegate '.modal.create-comment [name="text"]', 'keyup change', self.validate
        $d.delegate '.modal.create-comment [name="cancel"]', 'click', self.hide
        $('.modal.create-comment form').bindAjaxHandler self.handler

  class Relationships
    self = this

    @outgoingStatusHandler:
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
      $('.relationships-button a').bindAjaxHandler self.outgoingStatusHandler
      $('.relationships-button.follow a').bindAjaxHandler self.followHandler
      $('.relationships-button.unfollow a').bindAjaxHandler self.unfollowHandler

new Undersky
