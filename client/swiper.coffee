@page = (name) ->
  Session.set 'page', name
@pageIs = (name) ->
  Session.equals 'page', name
@getPage = () -> Session.get 'page'

pageWidth = ->
  pages = $('.pages')
  pages.width()


# render all pages
Template.slider.helpers
  pages: ->
    names = pageNames()
    # console.log names
    pages = _.map names, (name) ->
      name:name
      template:Template[name]
    return pages


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
  # delay 300, ->
  $('.page.'+name)?.css 'display', 'none'


canScroll = (location) ->
  Session.get location

drag = (posX)->
  width = pageWidth()

  if canScroll('left')
    # positive posx reveals left
    posX = Math.min(width, posX)
  else
    posX = Math.min(0, posX)

  if canScroll('right')
    # negative posx reveals right
    posX = Math.max(-width, posX)
  else
    posX = Math.max(0, posX)

  # update the page positions
  if canScroll('left')
    getPage('left').css 'transform',
      'translate3d(-' + (width - posX) + 'px,0,0)'

  if canScroll('right')
    getPage('right')?.css 'transform',
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

# If there are only 3 windows, you want to make sure not to animate
# the one that goes off screen or it will scrolla cross the view
moveLeft = ->
  right = Session.get('right')
  center = Session.get('center')
  left = Session.get('left')
  $('.page.'+right).removeClass('animate')
  $('.page.'+center).addClass('animate')
  $('.page.'+left).addClass('animate')
  page(left)

moveRight = ->
  right = Session.get('right')
  center = Session.get('center')
  left = Session.get('left')
  $('.page.'+left).removeClass('animate')
  $('.page.'+center).addClass('animate')
  $('.page.'+right).addClass('animate')
  page(right)


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
        moveRight()
      else if index is 1
        moveLeft()
      else
        animateBack()

      t.velX = 0
      t.startX = 0
      t.mouseX = 0
      t.changeX = 0
      t.mouseDown = false

  'touchend, touchcancel': (e,t) ->
    if t.mouseDown
      posX = t.changeX + t.posX
      width = pageWidth()

      momentum = Math.abs(10*t.velX)
      momentum = Math.min(momentum, width/2)
      momentum = momentum*sign(t.velX)

      index = Math.round((posX + momentum) / width)

      if index is -1
        moveRight()
      else if index is 1
        moveLeft()
      else
        animateBack()

      t.velX = 0
      t.startX = 0
      t.mouseX = 0
      t.changeX = 0
      t.mouseDown = false


@leftCenterRightHide = (left, center, right, hide) ->
  setPage 'left', left
  setPage 'center', center
  setPage 'right', right

  for hidden in hide
    setHidden hidden
