
class @Swipe
  constructor: (@templateNames) ->
    @state = new Package['reactive-dict'].ReactiveDict()
    @state.set 'page', null
    @state.set 'left', null
    @state.set 'right', null
    @t = null # template
    @lastPage = null

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


Template.swipe.helpers
  pages: -> _.map @Swiper.templateNames, (name) -> {name: name}


Template.swipe.rendered = ->
  # check that templateNames is passed
  if not @data.Swiper then console.log("ERROR: must pass a Swipe object.")
  @Swiper = @data.Swiper
  @Swiper.setTemplate(@)

  @width = $(@find('.pages')).width()

  t = @
  # react to window resizing!
  $(window).resize ->
    t.width = $(t.find('.pages')).width()
    t.Swiper.resize()


  # keep track of scrolling
  @startX = 0
  @mouseDown = false
  @mouseX = 0
  @posX = 0

Template.swipe.events
  'resize .pages': (e,t) ->
    console.log 'resizing!'
    # pageWidth

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


  'touchend, touchcancel .pages': (e,t) ->
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
