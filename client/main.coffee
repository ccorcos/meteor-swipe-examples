sign = (x) ->
  if x >= 0 then return 1 else return -1

Template.wrapper.helpers
  templateNames: ->
    templateNames = [
      'page1'
      'page2'
      'page3'
      'page4'
      'page5'
    ]
    return templateNames

Template.slider.helpers
  pages: ->
    pages = _.map @templateNames, (name) ->
      name:name
      template:Template[name]
    return pages

Template.slider.rendered = ->
  @numPages = @data?.templateNames?.length
  @startX = 0
  @mouseDown = false
  @mouseX = 0
  @posX = 0

# touchstart, mousedown
# touchmove, mousemove
# touchend, mouseup
Template.slider.events
  'mousedown .pages': (e,t) ->
    console.log "mousedown"
    # record where the touch started and set mouseDown true
    pages = $(e.currentTarget)
    pages.removeClass('animate')
    clickX = e.pageX
    t.startX = clickX
    t.mouseX = clickX
    t.mouseDown = true

  'touchstart .pages': (e,t) ->
    console.log "touchstart"
    # record where the touch started and set mouseDown true
    pages = $(e.currentTarget)
    pages.removeClass('animate')
    console.log e
    clickX = e.originalEvent.touches[0].pageX
    t.startX = clickX
    t.mouseX = clickX
    t.mouseDown = true

  'mousemove .pages': (e,t) ->
    if t.mouseDown
      console.log "move"
      # record where the mouse currently is and update based on the change
      pages = $(e.currentTarget)
      width = pages.width()
      pageWidth = width / (t.numPages)
      mouseX = e.pageX
      t.velX = mouseX - t.mouseX
      # console.log t.velX
      t.mouseX = mouseX
      changeX = mouseX - t.startX
      t.changeX = changeX
      posX = changeX + t.posX
      posX = Math.min(0, posX)
      posX = Math.max(-(width-pageWidth), posX)
      $(e.currentTarget).css 'transform',
        'translate3d(' + posX + 'px,0,0)'

  'touchmove .pages': (e,t) ->
    # need prevent default AND return false for touchend to work
    e.preventDefault()
    if t.mouseDown
      console.log "move"
      # record where the mouse currently is and update based on the change
      pages = $(e.currentTarget)
      width = pages.width()
      pageWidth = width / (t.numPages)
      mouseX = e.originalEvent.touches[0].pageX
      t.velX = mouseX - t.mouseX
      # console.log t.velX
      t.mouseX = mouseX
      changeX = mouseX - t.startX
      t.changeX = changeX
      posX = changeX + t.posX
      posX = Math.min(0, posX)
      posX = Math.max(-(width-pageWidth), posX)
      $(e.currentTarget).css 'transform',
        'translate3d(' + posX + 'px,0,0)'
    return false

  'mouseup, mouseout': (e,t) ->
    # alert("wtf")
    if t.mouseDown
      console.log "up"
      # remember the last posX for the next mouseDown
      posX = t.changeX + t.posX
      pages = $(t.find('.pages'))
      pageWidth = pages.width() / (t.numPages)

      momentum = Math.abs(10*t.velX)
      momentum = Math.min(momentum, pageWidth/2)
      momentum = momentum*sign(t.velX)

      pageIndex = Math.round((-posX-momentum) / pageWidth)
      pageIndex = Math.min(Math.max(0, pageIndex), t.numPages-1)
      snapX = -pageWidth*pageIndex
      t.posX = snapX

      pages.addClass('animate').css 'transform',
        'translate3d(' + snapX + 'px,0,0)'

      t.velX = 0
      t.startX = 0
      t.mouseX = 0
      t.changeX = 0
      t.mouseDown = false

  'touchend, touchcancel': (e,t) ->
    # alert("wtf")
    if t.mouseDown
      # alert("wtf")
      console.log "up"
      # remember the last posX for the next mouseDown
      posX = t.changeX + t.posX
      pages = $(t.find('.pages'))
      pageWidth = pages.width() / (t.numPages)

      momentum = Math.abs(10*t.velX)
      momentum = Math.min(momentum, pageWidth/2)
      momentum = momentum*sign(t.velX)

      pageIndex = Math.round((-posX-momentum) / pageWidth)
      pageIndex = Math.min(Math.max(0, pageIndex), t.numPages-1)
      snapX = -pageWidth*pageIndex
      t.posX = snapX

      pages.addClass('animate').css 'transform',
        'translate3d(' + snapX + 'px,0,0)'

      t.velX = 0
      t.startX = 0
      t.mouseX = 0
      t.changeX = 0
      t.mouseDown = false
