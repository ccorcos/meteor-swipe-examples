# EXAMPLE 4
# This example shows two swipers working

# Top infinitely scrolls an takes arrow keys
SwiperTop = new Swipe(['page3', 'page4', 'page5'], true)
# Bottom doesnt take arrow keys
SwiperBottom = new Swipe(['page1', 'page2'], false)


Template.ex4.helpers
  SwiperTop: -> SwiperTop
  SwiperBottom: -> SwiperBottom

# If an element controls swiping, make sure to include the `swipe-control` class.
# Then to use the control, use `swipeControl`.
SwiperBottom.swipeControl 'page1', '.next', (e,t) ->
  SwiperBottom.moveRight()

Template.ex4.rendered = ->

  # starting page
  SwiperTop.setPage('page3')
  SwiperBottom.setPage('page1')

  # page control
  Tracker.autorun ->
    if SwiperTop.pageIs('page3')
        SwiperTop.leftRight('page5', 'page4')

    else if SwiperTop.pageIs('page4')
      SwiperTop.leftRight('page3', 'page5')

    else if SwiperTop.pageIs('page5')
      SwiperTop.leftRight('page4', 'page3')

  # page control
  Tracker.autorun ->
    if SwiperBottom.pageIs('page1')
        SwiperBottom.leftRight(null, 'page2')

    else if SwiperBottom.pageIs('page2')
      SwiperBottom.leftRight('page1', null)
