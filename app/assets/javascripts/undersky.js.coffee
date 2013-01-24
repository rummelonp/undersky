###
# Undersky Definition
###

class Undersky
  $w = $(window)
  $d = $(document)

  class Growl
    @show: (text, level) ->
      $.bootstrapGrowl text,
        type: level
        offset:
          from: 'top'
          amount: 20

  class Loading
    @show: ->
      $('.page').addClass('loading')

    @hide: ->
      $('.page').removeClass('loading')

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
      name = form.find('[name="name"]').val()
      url = '/search'
      if name
        url += '/' + name
      location.href = url

    do ->
      $d.on 'submit', 'form[action="/search"]', self.submit

  class MediaGrid
    self = this
    column_offset = 140
    panel_offset = 75
    scroll_amount = 200

    @columns: ->
      $('.media-grid.photos a')

    @toggle: (e) ->
      return if e.hasModifierKey()
      e && e.preventDefault()
      panels = $('.modal.media-panel')
      panels.filter('.show').hide()
      columns = self.columns()
      column = $(this)
      id = column.data('id')
      actived = column.hasClass('actived')
      columns.filter('.actived, .focused').removeClass('actived').removeClass('focused')
      column.addClass('focused').focus()
      unless actived
        column.addClass('actived')
        panels.filter('[data-id="' + id + '"]').show()
        self.resize()

    @close: (e) ->
      e && e.preventDefault()
      columns = self.columns()
      columns.filter('.actived').removeClass('actived')
      panels = $('.modal.media-panel')
      panels.filter('.show').hide()

    @action: (e) ->
      return if e.hasModifierKey()
      return if $(e.target).isInput()
      switch e.which
        when 37, 75 # ←, k
          self.prev(e)
        when 39, 74 # →, j
          self.next(e)
        when 80 # p
          self.up(e)
        when 78 # n
          self.down(e)

    @prev: (e) ->
      columns = self.columns()
      column = columns.filter('.focused')
      if column.size()
        column = column.parent().prev().find('a').first()
      if column.size()
        self.toggle.call(column, e)
        $w.scrollTop(column.offset().top - column_offset)

    @next: (e) ->
      columns = self.columns()
      column = columns.filter('.focused')
      if column.size()
        column = column.parent().next().find('a').first()
      else
        column = columns.first()
      if column.size()
        self.toggle.call(column, e)
        $w.scrollTop(column.offset().top - column_offset)

    @up: (e) ->
      e && e.preventDefault()
      panel = $('.modal.media-panel.show')
      panel.scrollTop(panel.scrollTop() - scroll_amount)

    @down: (e) ->
      e && e.preventDefault()
      panel = $('.modal.media-panel.show')
      panel.scrollTop(panel.scrollTop() + scroll_amount)

    @resize: ->
      $('.modal.media-panel.show').css('height', $w.height() - panel_offset)

    do ->
      $d.on 'click', '.media-grid.photos a', self.toggle
      $d.on 'click', '.modal.media-panel .close', self.close
      $d.on 'keydown', self.action
      $w.on 'resize', self.resize

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
        container = self.parents('.likes')
        container.children().remove()
        container.append(data)
      error: (e, data) ->
        self = $(this)
        spinner = self.data('spinner')
        spinner.hide()
        Growl.show('Failed to load likes, try again later', 'error')

    @likesStatusHandler:
      beforeSend: (e) ->
        $(this).disableElement()
      complete: (e, data) ->
        $(this).enableElement()

    @likeHandler:
      success: (e, data) ->
        self = $(this)
        status = $(this).parents('.likes-status')
        status.removeClass('unlike').addClass('like')
        panel = self.parents('.modal.media-panel')
        count = panel.find('.likes-count .count').incText().intText()
        panel.find('[data-likes-count]').attr('data-likes-count', count)
        panel.find('.likes-data').prepend(data)
      error: (e, data) ->
        Growl.show('Failed to like, try again later', 'error')

    @unlikeHandler:
      success: (e, data) ->
        self = $(this)
        user = $d.data('user')
        status = self.parents('.likes-status')
        status.removeClass('like').addClass('unlike')
        panel = self.parents('.modal.media-panel')
        count = panel.find('.likes-count .count').decText().intText()
        panel.find('[data-likes-count]').attr('data-likes-count', count)
        panel.find('.likes-data [data-username="' + user.username + '"]').remove()
      error: (e, data) ->
        Growl.show('Failed to unlike, try again later', 'error')

    @action: (e) ->
      return if e.hasModifierKey()
      return if $(e.target).isInput()
      return if e.which != 76 # l
      panel = $('.modal.media-panel.show')
      return if panel.size() == 0
      e && e.preventDefault()
      likes_status = panel.find('.likes-status')
      if likes_status.hasClass('like')
        likes_status.find('.likes-button.unlike a').click()
      else
        likes_status.find('.likes-button.like a').click()

    do ->
      $('.likes-load-link a').bindAjaxHandler self.likesHandler
      $('.likes-button a').bindAjaxHandler self.likesStatusHandler
      $('.likes-button.like a').bindAjaxHandler self.likeHandler
      $('.likes-button.unlike a').bindAjaxHandler self.unlikeHandler
      $d.on 'keydown', self.action

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
        container = self.parents('.comments')
        container.children().remove()
        container.append(data)
      error: (e, data) ->
        self = $(this)
        spinner = self.data('spinner')
        spinner.hide()
        Growl.show('Failed to load comments, try again later', 'error')

    @deleteCommentHandler:
      beforeSend: (e) ->
        $(this).__hide()
      success: (e, data) ->
        self = $(this)
        user = $d.data('user')
        panel = self.parents('.modal.media-panel')
        count = panel.find('.comments-count .count').decText().intText()
        panel.find('[data-comments-count]').attr('data-comments-count', count)
        panel.find('.comments-data [data-username="' + user.username + '"]').remove()
      error: (e, data) ->
        $(this).__show()
        Growl.show('Failed to delete comment, try again later', 'error')

    do ->
      $('.comments-load-link a').bindAjaxHandler self.commentsHandler
      $('.comments-button.delete-comment a').bindAjaxHandler self.deleteCommentHandler

  class CreateComment
    self = this

    @show: (e) ->
      e && e.preventDefault()
      container = $('.modal.create-comment')
      if container.size() > 0
        return container.find('textarea').focus()
      self = $(this)
      panel = self.parents('.modal.media-panel')
      caption_data = panel.find('.caption').children()
      comments_data = panel.find('.comments-data').children()
      container = $('<div class="modal create-comment" data-id="' + panel.data('id') + '"></div>')
      form = $('<form action="' + self.attr('href') + '" method="post" data-remote="true"></form>')
      header = $('<div class="modal-header">comment</div>')
      body = $('<div class="modal-body"><textarea name="text" rows="4" cols="50" required="required"></textarea></div>')
      footer = $('<div class="modal-footer"></div>')
      footer.append('<div class="pull-left"><input class="btn primary" name="commit" type="submit" value="comment" disabled="disabled" /></div>')
      footer.append('<div class="pull-left"><input class="btn" name="cancel" type="reset" value="cancel" /></div>')
      form.append(header, body, footer)
      if caption_data.size() > 0
        caption = $('<div class="modal-footer caption"></div>')
        caption.append(caption_data.clone())
      form.append(caption)
      if comments_data.size() > 0
        comments = $('<div class="modal-footer comments"></div>')
        comments.append(comments_data.clone())
        comments.find('.comments-button.delete-comment').remove()
        form.append(comments)
      container.append(form)
      container.modal('show')
      container.bind('hidden', -> container.remove())
      container.find('textarea').focus()

    @reply: (e) ->
      e && e.preventDefault()
      self = $(this)
      username = '@' + $(this).text() + ' ';
      textarea = self.parents('.modal.create-comment').find('textarea')
      textarea.focus()
      textarea.val(username + textarea.val().replace(username, ''))

    @tag: (e) ->
      e && e.preventDefault()
      self = $(this)
      tag = ' ' + $(this).text();
      textarea = self.parents('.modal.create-comment').find('textarea')
      textarea.focus()
      textarea.val(textarea.val().replace(tag, '') + tag)

    @validate: (e) ->
      self = $(this)
      commit = $(this).parents('.modal.create-comment').find('[name="commit"]')
      if self.val().length > 0
        commit.enableElement()
      else
        commit.disableElement()

    @hide: (e) ->
      e && e.preventDefault()
      $(this).parents('.modal.create-comment').modal('hide')

    @handler:
      beforeSend: (e) ->
        self = $(this)
        self.find('input, textarea').each(-> $(this).disableElement())
      success: (e, data) ->
        self = $(this)
        panel = do ->
          container = self.parents('.modal.create-comment')
          container.modal('hide')
          $('[data-id="' + container.data('id') + '"]')
        return if panel.size() == 0
        container = panel.find('.comments-data')
        if container.size() == 0
          comments = $('<div class="modal-footer comments"></div>')
          count = $('<div class="comments-count"></div>')
          count.append('<span class="count">1</span> comments</span>')
          container = $('<div class="comments-data"></div>')
          comments.append(count, container)
          caption = panel.find('.caption')
          if caption.size() > 0
            caption.after(comments)
          else
            panel.find('.status').after(comments)
        else
          panel.find('.comments-count .count').incText()
        container.append(data)
      error: (e, ddata) ->
        Growl.show('Failed to create comment, try again later', 'error')
      complete: (e, data) ->
        self = $(this)
        self.find('input, textarea').each(-> $(this).enableElement())

    @action: (e) ->
      return if e.hasModifierKey()
      return if $(e.target).isInput()
      return if e.which != 67 # c
      panel = $('.modal.media-panel.show')
      return if panel.size() == 0
      e && e.preventDefault()
      panel.find('.comments-button.create-comment a').click()

    do ->
      $('.modal.create-comment form').bindAjaxHandler self.handler
      $d.on 'click', '.comments-button.create-comment a', self.show
      $d.on 'click', '.modal.create-comment .username a', self.reply
      $d.on 'click', '.modal.create-comment a.tag', self.tag
      $d.on 'keyup change', '.modal.create-comment [name="text"]', self.validate
      $d.on 'click', '.modal.create-comment [name="cancel"]', self.hide
      $d.on 'keydown', self.action

  class Location
    self = this

    @show: ->
      map = $('.map')
      data = map.data()
      gmaps = new GMaps
        div: map.get(0)
        lat: data.latitude
        lng: data.longitude
      gmaps.addMarker
        lat: data.latitude
        lng: data.longitude
        title: data.name

    do ->
      if location.pathname.match(/^\/location\/\d+/)
        $d.ready self.show

  class Nearby
    self = this

    @nearby: ->
      map = $('.map')
      gmaps = new GMaps
        div: map.get(0)
        lat: 35.685326
        lng: 139.7531
      GMaps.geolocate
        success: (position) ->
          lat = position.coords.latitude
          lng = position.coords.longitude
          gmaps.setCenter(lat, lng)
          self.load(lat, lng)
        error: (error) ->
          Growl.show('Geolocation failed: ' + error.message, 'error')
        not_supported: ->
          Growl.show("Your browser does not support geolocation", 'error')

    @load: (lat, lng) ->
      isLoadedLocation = false
      isLoadedMedia = false
      hideLoadingIfLoaded = ->
        Loading.hide() if isLoadedLocation && isLoadedMedia
      Loading.show()
      $.ajax
        url: '/location/search.html'
        data:
          lat: lat
          lng: lng
        beforeSend: ->
          Growl.show('Load nearby places...', 'info')
        success: (data) ->
          $('.nearby').append(data)
          isLoadedLocation = true
          hideLoadingIfLoaded()
        error: ->
          Growl.show('Failed to load nearby places, please reload', 'error')
      $.ajax
        url: '/media/search.html'
        data:
          lat: lat
          lng: lng
        beforeSend: ->
          Growl.show('Load nearby media...', 'info')
        success: (data) ->
          window.data = data
          data = $(data)
          $('.media-grid').append(data.find('.media-grid > *'))
          $('.modal-container').append(data.find('.modal-container > *'))
          isLoadedMedia = true
          hideLoadingIfLoaded()
        error: ->
          Growl.show('Failed to load nearby media, please reload', 'error')

    do ->
      if location.pathname.match(/^\/location\/nearby$/)
        $d.ready self.nearby

  class Relationships
    self = this

    @outgoingStatusHandler:
      beforeSend: (e) ->
        $(this).disableElement()
      success: (e, data) ->
        status = $(this).parents('.outgoing-status')
        status.removeClass().addClass('outgoing-status').addClass(data.outgoing_status.replace(/_/g, '-'))
      complete: (e, data) ->
        $(this).enableElement()

    @followHandler:
      error: (e, data) ->
        Growl.show('Failed to follow, try again later', 'error')

    @unfollowHandler:
      error: (e, data) ->
        Growl.show('Failed to unfollow, try again later', 'error')

    do ->
      $('.relationships-button a').bindAjaxHandler self.outgoingStatusHandler
      $('.relationships-button.follow a').bindAjaxHandler self.followHandler
      $('.relationships-button.unfollow a').bindAjaxHandler self.unfollowHandler

  class Page
    self = this

    @loadNextPage: (e) ->
      if $d.height() - ($d.scrollTop() + $w.height()) < 500
        $('.page-button.next-page a').click()

    @nextPageHandler:
      beforeSend: (e) ->
        $(this).disableElement()
      success: (e, data) ->
        self = $(this)
        data = $(data)
        $('.media-grid').append(data.find('.media-grid > *'))
        $('.modal-container').append(data.find('.modal-container > *'))
        self.replaceWith(data.find('.page-button.next-page a'))
      error: (e, data) ->
        $(this).enableElement()
        Growl.show('Failed to load next page, try again later', 'error')

    do ->
      $('.page-button.next-page a').bindAjaxHandler self.nextPageHandler
      $w.on 'scroll', self.loadNextPage
