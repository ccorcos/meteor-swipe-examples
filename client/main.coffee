#
# UTILS
#
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

#
# PAGES
#
pageNames = ->
  [
    'page1'
    'page2'
    'page3'
    'page4'
    'page5'
  ]

numPages = ->
  pageNames().length

pageWidth = ->
  pages = $('.pages')
  pages.width()

Session.setDefault 'pageIndex', 0

#
# SETUP
#
Template.slider.helpers
  pages: ->
    names = pageNames()
    console.log names
    pages = _.map names, (name) ->
      name:name
      template:Template[name]
    return pages



#
# HELPERS
#
getPage = (location) ->
  name = Session.get location
  if name then return $('.page.'+name) else return false

setPage = (location, name) ->
  Session.set location, name
  width = pageWidth()
  x = [-width, 0, width][['left', 'center', 'right'].indexOf(location)]
  $('.page.'+name)?.css('display', 'block').css 'transform',
    'translate3d('+x+'px,0,0)'

setHidden = (name) ->
  $('.page.'+name)?.css 'display', 'none'


canScroll = (location) ->
  Session.get location

drag = (posX)->
  width = pageWidth()

  if canScroll('left')
    # positive posx reveals left
    posX = Math.min(width, posX)
  else
    posX = Math.max(0, posX)

  if canScroll('right')
    # negative posx reveals right
    posX = Math.max(-width, posX)
  else
    posX = Math.min(0, posX)

  # update the page positions
  getPage('left').css 'transform',
    'translate3d(-' + (width - posX) + 'px,0,0)'

  getPage('right').css 'transform',
    'translate3d(' + (width + posX) + 'px,0,0)'

  getPage('center').css 'transform',
    'translate3d(' + posX + 'px,0,0)'

animateBack = ->
  width = pageWidth()

  for name in pageNames()
    $('.page.'+name).addClass('animate')

  getPage('left')?.css 'transform',
    'translate3d(-' + width +  'px,0,0)'

  getPage('right')?.css 'transform',
    'translate3d(' + width + 'px,0,0)'

  getPage('center')?.css 'transform',
    'translate3d(0px,0,0)'

moveLeft = ->
  index = Session.get 'pageIndex'
  index = index - 1
  max = numPages() - 1
  index = wrap(0, max, index)
  Session.set 'pageIndex', index

moveRight = ->
  index = Session.get 'pageIndex'
  index = index + 1
  max = numPages() - 1
  index = wrap(0, max, index)
  Session.set 'pageIndex', index


#
# RENDER
#
Template.slider.rendered = ->

  firstTime = true
  #
  # TRANSITION AUTORUN
  #
  Tracker.autorun ->
    # console.log "autorun"
    center = Session.get 'pageIndex'
    left = wrap(0, numPages()-1, center-1)
    right = wrap(0, numPages()-1, center+1)
    num = numPages()
    names = pageNames()

    if firstTime
      firstTime = false
    else
      for name in names
        $('.page.'+name).addClass('animate')

    for index in _.difference([0..num-1], [center, right, left])
      setHidden(names[index])

    setPage 'left', names[left]
    setPage 'center', names[center]
    setPage 'right', names[right]

  # keep track of scrolling
  @startX = 0
  @mouseDown = false
  @mouseX = 0
  @posX = 0


#
# TOUCH DRAG
#
Template.slider.events
  'mousedown .pages': (e,t) ->
    # console.log "mousedown"
    # record where the touch started and set mouseDown true
    $('.animate').removeClass('animate')
    pages = $(e.currentTarget)
    clickX = e.pageX
    t.startX = clickX
    t.mouseX = clickX
    t.mouseDown = true

  'touchstart .pages': (e,t) ->
    # console.log "touchstart"
    # record where the touch started and set mouseDown true
    $('.animate').removeClass('animate')
    pages = $(e.currentTarget)
    clickX = e.originalEvent.touches[0].pageX
    t.startX = clickX
    t.mouseX = clickX
    t.mouseDown = true

  'mousemove .pages': (e,t) ->
    if t.mouseDown
      # console.log "move"
      # record where the mouse currently is and update based on the change
      pages = $(e.currentTarget)
      mouseX = e.pageX
      t.velX = mouseX - t.mouseX
      t.mouseX = mouseX
      changeX = mouseX - t.startX
      t.changeX = changeX
      posX = changeX + t.posX

      drag(posX)


  'touchmove .pages': (e,t) ->
    # need prevent default AND return false for touchend to work
    e.preventDefault()
    if t.mouseDown
      # console.log "move"
      # record where the mouse currently is and update based on the change
      pages = $(e.currentTarget)
      mouseX = e.originalEvent.touches[0].pageX
      t.velX = mouseX - t.mouseX
      t.mouseX = mouseX
      changeX = mouseX - t.startX
      t.changeX = changeX
      posX = changeX + t.posX

      drag(posX)
    return false

  'mouseup, mouseout': (e,t) ->
    if t.mouseDown
      # console.log "up"
      # remember the last posX for the next mouseDown
      posX = t.changeX + t.posX
      width = pageWidth()

      momentum = Math.abs(10*t.velX)
      momentum = Math.min(momentum, width/2)
      momentum = momentum*sign(t.velX)

      index = Math.round((posX + momentum) / width)

      if index is -1
        # go right
        # console.log "move right"
        moveRight()
      else if index is 1
        # right
        # console.log "move left"
        moveLeft()
      else
        # console.log "move back"
        animateBack()

      t.velX = 0
      t.startX = 0
      t.mouseX = 0
      t.changeX = 0
      t.mouseDown = false

  'touchend, touchcancel': (e,t) ->
    if t.mouseDown
      # console.log "up"
      # remember the last posX for the next mouseDown
      posX = t.changeX + t.posX
      width = pageWidth()

      momentum = Math.abs(10*t.velX)
      momentum = Math.min(momentum, width/2)
      momentum = momentum*sign(t.velX)

      index = Math.round((posX + momentum) / width)

      if index is -1
        # go right
        console.log "move right"
        moveRight()
      else if index is 1
        # right
        console.log "move left"
        moveLeft()
      else
        console.log "move back"
        animateBack()

      t.velX = 0
      t.startX = 0
      t.mouseX = 0
      t.changeX = 0
      t.mouseDown = false
