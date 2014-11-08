

class Swipe
  constructor: (@templateNames, arrowKeys=true) ->
    @state = new Package['reactive-dict'].ReactiveDict()
    @state.set 'page', null
    @state.set 'left', null
    @state.set 'right', null
    @t = null # template
    @lastPage = null

    self = @
    # react to window resizing!
    $(window).resize ->
      self.t?.width = $(self.t?.find('.pages')).width()
      self.resize()

    if arrowKeys
      document.onkeydown = (e) ->
        if not e then e = window.event
        code = e.keyCode
        if code is 37
          # let moveLeft handle the animations. This fixes the 3 page example.
          $(self.t?.findAll('.animate')).removeClass('animate')
          self.moveLeft()
        else if code is 39
          # let moveLeft handle the animations. This fixes the 3 page example.
          $(self.t?.findAll('.animate')).removeClass('animate')
          self.moveRight()
        # else if code is 38 # up
        # else if code is 40 # down
        event.preventDefault()


  setTemplate: (t) ->
    @t = t

  getPage: () ->
    @state.get 'page'

  setPage: (name) ->
    @lastPage = @getPage()
    @state.set 'page', name
    # set position in the middle regardless of animation
    $(@t.find('.page.'+name)).css('display', 'block').css 'transform',
      'translate3d(0px,0,0)'

  pageIs: (name) ->
    @state.equals 'page', name

  getLeft: () ->
    @state.get 'left'

  setLeft: (name) ->
    @state.set 'left', name
    # set position in the left regardless of animation
    $(@t.find('.page.'+name)).css('display', 'block').css 'transform',
      'translate3d(-'+@t.width+'px,0,0)'

  leftIs: (name) ->
    @state.equals 'left', name

  getRight: () ->
    @state.get 'right'

  setRight: (name) ->
    @state.set 'right', name
    # set position in the middle regardless of animation
    $(@t.find('.page.'+name)).css('display', 'block').css 'transform',
      'translate3d('+@t.width+'px,0,0)'

  rightIs: (name) ->
    @state.equals 'right', name


  drag: (posX) ->
    width = @t.width

    # Cant scroll in the direction where there is no page!
    if @getLeft()
      # positive posx reveals left
      posX = Math.min(width, posX)
    else
      posX = Math.min(0, posX)

    if @getRight()
      # negative posx reveals right
      posX = Math.max(-width, posX)
    else
      posX = Math.max(0, posX)

    # update the page positions
    if @getLeft()
      $(@t.find('.page.'+@getLeft())).css 'transform',
        'translate3d(-' + (width - posX) + 'px,0,0)'
    if @getRight()
      $(@t.find('.page.'+@getRight())).css 'transform',
        'translate3d(' + (width + posX) + 'px,0,0)'
    $(@t.find('.page.'+@getPage())).css 'transform',
      'translate3d(' + posX + 'px,0,0)'

  animateBack: () ->
    # Animate all pages back into place
    $(@t.findAll('.page')).addClass('animate')

    if @getLeft()
      $(@t.find('.page.'+@getLeft())).css 'transform',
        'translate3d(-' + @t.width + 'px,0,0)'
    if @getRight()
      $(@t.find('.page.'+@getRight())).css 'transform',
        'translate3d(' + @t.width + 'px,0,0)'
    $(@t.find('.page.'+@getPage())).css 'transform',
      'translate3d(0px,0,0)'


  moveLeft: () ->
    if @getLeft()
      # only animate the center and the left towards the right
      $(@t.find('.page.'+@getPage())).addClass('animate').css 'transform',
        'translate3d('+@t.width+'px,0,0)'
      $(@t.find('.page.'+@getLeft())).addClass('animate').css 'transform',
        'translate3d(0px,0,0)'
      @setPage(@getLeft())

  moveRight: () ->
    if @getRight()
      # only animate the center and the left towards the right
      $(@t.find('.page.'+@getPage())).addClass('animate').css 'transform',
        'translate3d(-'+@t.width+'px,0,0)'
      $(@t.find('.page.'+@getRight())).addClass('animate').css 'transform',
        'translate3d(0px,0,0)'
      @setPage(@getRight())

  leftRight: (left, right) ->
    oldLeft = @getLeft()
    oldRight = @getRight()


    center = @getPage()
    @setLeft(left)
    @setRight(right)

    # dont hide the old center!
    for name in _.difference(@templateNames, [left, center, right, @lastPage])
      $(@t.find('.page.'+name)).css 'display', 'none'

  resize: ->
    $(@t.findAll('.animate')).removeClass('animate')
    @setLeft(@getLeft())
    @setRight(@getRight())

  # These are effectively the same:

  # swipeControl Swiper, 'page1', '.next', (e,t) ->
  #   Swiper.moveRight()

  # Template.page1.events
  #   'mouseup .next': (e,t) ->
  #     console.log e
  #     Swiper.moveRight()
  #
  #   'touchend .next': (e,t) ->
  #     if e.currentTarget is Swiper.element
  #       Swiper.moveRight()

  swipeControl: (template, selector, handler) ->
    Swiper = @
    mouseup = 'mouseup ' + selector
    touchend = 'touchend ' + selector
    eventMap = {}
    eventMap[mouseup] = (e,t) ->
      handler(e,t)
    eventMap[touchend] = (e,t) ->
      if e.currentTarget is Swiper.element
        handler(e,t)
    Template[template].events eventMap


Template.swipe.helpers
  pages: -> _.map @Swiper?.templateNames, (name) -> {name: name}


Template.swipe.rendered = ->
  # check that templateNames is passed
  if not @data.Swiper
    console.log("ERROR: must pass a Swipe object.")
  else
    @Swiper = @data.Swiper
    @Swiper.setTemplate(@)

  @width = $(@find('.pages')).width()





  # keep track of scrolling
  @startX = 0
  @mouseDown = false
  @mouseX = 0
  @posX = 0

Template.swipe.events
  'mousedown .pages': (e,t) ->
    unless $(e.target).hasClass('no-swipe')
      # remove stop all animations in this swiper
      $(t.findAll('.animate')).removeClass('animate')
      clickX = e.pageX
      t.startX = clickX # beginning of the swipe
      t.mouseX = clickX # current position of the swipe
      t.mouseDown = true # swipe has begun

  'touchstart .pages': (e,t) ->
    unless $(e.target).hasClass('no-swipe')

      # keep track of what element the pointer is over for touchend
      x = e.originalEvent.touches[0].pageX - window.pageXOffset
      y = e.originalEvent.touches[0].pageY - window.pageYOffset
      target = document.elementFromPoint(x, y)
      t.Swiper.element = target

      # remove stop all animations in this swiper
      $(t.findAll('.animate')).removeClass('animate')
      clickX = e.originalEvent.touches[0].pageX
      t.startX = clickX # beginning of the swipe
      t.mouseX = clickX # current position of the swipe
      t.mouseDown = true # swipe has begun

  'mousemove .pages': (e,t) ->

    if t.mouseDown
      newMouseX = e.pageX
      oldMouseX = t.mouseX
      t.velX = newMouseX - oldMouseX
      t.changeX = newMouseX - t.startX
      posX = t.changeX + t.posX
      t.mouseX = newMouseX
      t.Swiper.drag(posX)

  'touchmove .pages': (e,t) ->
    # need prevent default AND return false for touchend to work
    e.preventDefault()

    # keep track of what element the pointer is over for touchend
    x = e.originalEvent.touches[0].pageX - window.pageXOffset
    y = e.originalEvent.touches[0].pageY - window.pageYOffset
    target = document.elementFromPoint(x, y)
    t.Swiper.element = target

    if t.mouseDown
      newMouseX = e.originalEvent.touches[0].pageX
      oldMouseX = t.mouseX
      t.velX = newMouseX - oldMouseX
      t.changeX = newMouseX - t.startX
      posX = t.changeX + t.posX
      t.mouseX = newMouseX
      t.Swiper.drag(posX)
    return false

  'mouseup .pages': (e,t) ->
    if $(e.target).hasClass('swipe-control')
      t.velX = 0
      t.startX = 0
      t.mouseX = 0
      t.changeX = 0
      t.mouseDown = false
    else
      if t.mouseDown
        posX = t.changeX + t.posX
        momentum = Math.abs(10*t.velX)
        momentum = Math.min(momentum, t.width/2)
        momentum = momentum*sign(t.velX)
        index = Math.round((posX + momentum) / t.width)
        if index is -1
          t.Swiper.moveRight()
        else if index is 1
          t.Swiper.moveLeft()
        else
          t.Swiper.animateBack()

        t.velX = 0
        t.startX = 0
        t.mouseX = 0
        t.changeX = 0
        t.mouseDown = false

  'mouseout .pages': (e,t) ->
    if t.mouseDown
      parentToChild = e.fromElement is e.toElement.parentNode
      childToParent = _.contains(e.toElement.childNodes, e.fromElement)
      if not (parentToChild or childToParent)
        posX = t.changeX + t.posX
        momentum = Math.abs(10*t.velX)
        momentum = Math.min(momentum, t.width/2)
        momentum = momentum*sign(t.velX)
        index = Math.round((posX + momentum) / t.width)
        if index is -1
          t.Swiper.moveRight()
        else if index is 1
          t.Swiper.moveLeft()
        else
          t.Swiper.animateBack()

        t.velX = 0
        t.startX = 0
        t.mouseX = 0
        t.changeX = 0
        t.mouseDown = false

    scrollOffPage = e.toElement is document.querySelector("html")
    if scrollOffPage
      # Not handling this well
      t.velX = 0
      t.startX = 0
      t.mouseX = 0
      t.changeX = 0
      t.mouseDown = false

  # mouseout and touchcancel
  'touchend .pages': (e,t) ->
    if $(e.target).hasClass('swipe-control') and e.target is t.Swiper.element
      t.velX = 0
      t.startX = 0
      t.mouseX = 0
      t.changeX = 0
      t.mouseDown = false
    else
      if t.mouseDown
        posX = t.changeX + t.posX
        momentum = Math.abs(10*t.velX)
        momentum = Math.min(momentum, t.width/2)
        momentum = momentum*sign(t.velX)
        index = Math.round((posX + momentum) / t.width)
        if index is -1
          t.Swiper.moveRight()
        else if index is 1
          t.Swiper.moveLeft()
        else
          t.Swiper.animateBack()
        t.velX = 0
        t.startX = 0
        t.mouseX = 0
        t.changeX = 0
        t.mouseDown = false




sign = (x) ->
  if x >= 0 then return 1 else return -1

bound = (min, max, n) ->
  Math.min(Math.max(min, n), max)

wrap = (min, max, n) ->
  if n < min
    return max - (min - 1) - 1
  else if n > max
    return min + (n - max) - 1
  else
    return n


delay = (ms, func) -> setTimeout func, ms
