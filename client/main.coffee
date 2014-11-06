sign = (x) ->
  if x >= 0 then return 1 else return -1

Session.setDefault 'templateNames', [
  'page1'
  'page2'
  'page3'
  'page4'
  'page5'
]

getTemplateNames = -> Session.get 'templateNames'



# page names are kept track of in "centerPage", "leftPage", "rightPage"
centerPage = ->
  name = Session.get 'centerPage'
  if name then return $('.page.'+name) else return false

rightPage = ->
  name = Session.get 'rightPage'
  if name then return $('.page.'+name) else return false

leftPage = ->
  name = Session.get 'leftPage'
  if name then return $('.page.'+name) else return false



# set the page
setCenter = (name) ->
  console.log "center:", name
  Session.set 'centerPage', name
  $('.page.'+name)?.css('display', 'block').css 'transform',
    'translate3d(0,0,0)'

setRight = (name) ->
  console.log "right:", name
  Session.set 'rightPage', name
  pageWidth = $('.pages').width()
  $('.page.'+name)?.css('display', 'block').css 'transform',
    'translate3d(' + pageWidth + 'px,0,0)'

setLeft = (name) ->
  console.log "left:", name
  Session.set 'leftPage', name
  pageWidth = $('.pages').width()
  $('.page.'+name)?.css('display', 'block').css 'transform',
    'translate3d(-' + pageWidth + 'px,0,0)'

setHidden = (name) ->
  $('.page.'+name)?.css 'display', 'none'



canScrollLeft = ->
  Session.get 'leftPage'

canScrollRight = ->
  Session.get 'rightPage'



moveLeft = ->
  index = Session.get 'currentPageIndex'
  index = index - 1
  max = Session.get('templateNames').length-1
  if index > max
    index = 0
  else if index < 0
    index = max

  console.log index
  Session.set 'currentPageIndex', index

moveRight = ->
  index = Session.get 'currentPageIndex'
  index = index + 1
  max = Session.get('templateNames').length-1
  if index > max
    index = 0
  else if index < 0
    index = max
  Session.set 'currentPageIndex', index

Template.slider.helpers
  pages: ->
    names = getTemplateNames()
    console.log names
    pages = _.map names, (name) ->
      name:name
      template:Template[name]
    return pages


Template.slider.rendered = ->
  # names = ['page1', 'page2', 'page3', 'page4', 'page5']
  @names = getTemplateNames()
  names = @names
  @num = @names.length
  num = @num

  # keep track of the page being viewed
  Session.set 'currentPageIndex', 0

  # when the currentPAgeIndex changes, animate to position
  Tracker.autorun ->
    console.log "autorun"
    pages = $('.pages')
    pageWidth = pages.width()

    page = Session.get 'currentPageIndex'

    center = page
    left = center-1
    right = page+1

    console.log left, center, right

    if left < 0 then left = num-1
    if right > num-1 then right = 0

    console.log left, center, right

    for name in names
      $('.page.'+name).addClass('animate')

    for index in _.difference([0..num], [center, right, left])
      setHidden(names[index])

    setLeft names[left]
    setRight names[right]
    setCenter names[center]

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
    $('.animate').removeClass('animate')
    pages = $(e.currentTarget)
    clickX = e.pageX
    t.startX = clickX
    t.mouseX = clickX
    t.mouseDown = true

  # 'touchstart .pages': (e,t) ->
  #   console.log "touchstart"
  #   # record where the touch started and set mouseDown true
  #   $('.animate').removeClass('animate')
  #   pages = $(e.currentTarget)
  #   clickX = e.originalEvent.touches[0].pageX
  #   t.startX = clickX
  #   t.mouseX = clickX
  #   t.mouseDown = true

  'mousemove .pages': (e,t) ->
    if t.mouseDown
      console.log "move"
      # record where the mouse currently is and update based on the change
      pages = $(e.currentTarget)
      pageWidth = pages.width()
      mouseX = e.pageX
      t.velX = mouseX - t.mouseX
      # console.log t.velX
      t.mouseX = mouseX
      changeX = mouseX - t.startX
      t.changeX = changeX
      posX = changeX + t.posX

      if canScrollLeft()
        # positive posx reveals left
        posX = Math.min(pageWidth, posX)
      else
        posX = Math.max(0, posX)

      if canScrollRight()
        # negative posx revealst right
        posX = Math.max(-pageWidth, posX)
      else
        posX = Math.min(0, posX)

      console.log Session.get('leftPage'), Session.get('centerPage'), Session.get('rightPage')

      # console.log (pageWidth - posX)
      # console.log "left: ", -(pageWidth - posX)
      # console.log "center", posX
      # console.log "right", (pageWidth - posX)
      leftPage().css 'transform',
        'translate3d(-' + (pageWidth - posX) + 'px,0,0)'

      # console.log pageWidth
      # console.log posX
      rightPage().css 'transform',
        'translate3d(' + (pageWidth + posX) + 'px,0,0)'

      centerPage().css 'transform',
        'translate3d(' + posX + 'px,0,0)'


  # 'touchmove .pages': (e,t) ->
  #   # need prevent default AND return false for touchend to work
  #   e.preventDefault()
  #   if t.mouseDown
  #     console.log "move"
  #     # record where the mouse currently is and update based on the change
  #     pages = $(e.currentTarget)
  #     width = pages.width()
  #     pageWidth = width / (t.numPages)
  #     mouseX = e.originalEvent.touches[0].pageX
  #     t.velX = mouseX - t.mouseX
  #     # console.log t.velX
  #     t.mouseX = mouseX
  #     changeX = mouseX - t.startX
  #     t.changeX = changeX
  #     posX = changeX + t.posX
  #     posX = Math.min(0, posX)
  #     posX = Math.max(-(width-pageWidth), posX)
  #     $(e.currentTarget).css 'transform',
  #       'translate3d(' + posX + 'px,0,0)'
  #   return false

  'mouseup, mouseout': (e,t) ->
    # alert("wtf")
    if t.mouseDown
      console.log "up"
      # remember the last posX for the next mouseDown
      posX = t.changeX + t.posX
      pages = $(t.find('.pages'))
      pageWidth = pages.width()

      momentum = Math.abs(10*t.velX)
      momentum = Math.min(momentum, pageWidth/2)
      momentum = momentum*sign(t.velX)

      index = Math.round((posX + momentum) / pageWidth)
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
        for name in getTemplateNames()
          $('.page.'+name).addClass('animate')

        leftPage()?.css 'transform',
          'translate3d(-' + pageWidth +  'px,0,0)'

        rightPage()?.css 'transform',
          'translate3d(' + pageWidth + 'px,0,0)'

        centerPage()?.css 'transform',
          'translate3d(0px,0,0)'

      t.velX = 0
      t.startX = 0
      t.mouseX = 0
      t.changeX = 0
      t.mouseDown = false

  # 'touchend, touchcancel': (e,t) ->
  #   # alert("wtf")
  #   if t.mouseDown
  #     # alert("wtf")
  #     console.log "up"
  #     # remember the last posX for the next mouseDown
  #     posX = t.changeX + t.posX
  #     pages = $(t.find('.pages'))
  #     pageWidth = pages.width() / (t.numPages)
  #
  #     momentum = Math.abs(10*t.velX)
  #     momentum = Math.min(momentum, pageWidth/2)
  #     momentum = momentum*sign(t.velX)
  #
  #     pageIndex = Math.round((-posX-momentum) / pageWidth)
  #     pageIndex = Math.min(Math.max(0, pageIndex), t.numPages-1)
  #     snapX = -pageWidth*pageIndex
  #     t.posX = snapX
  #
  #     pages.addClass('animate').css 'transform',
  #       'translate3d(' + snapX + 'px,0,0)'
  #
  #     t.velX = 0
  #     t.startX = 0
  #     t.mouseX = 0
  #     t.changeX = 0
  #     t.mouseDown = false
