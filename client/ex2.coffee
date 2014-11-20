
# EXAMPLE 2
# 3 page infinite scrolling
# Make sure that when moving left, the left page moves to the right without
# animating across the screen

Swiper = new Swipe(['page1', 'page2', 'page3'])

Template.ex2.helpers
  Swiper: -> Swiper

# If an element controls swiping, make sure to include the `swipe-control` class.
# Then to use the control, use `swipeControl`.
Swiper.swipeControl 'page1', '.next', (e,t) ->
  Swiper.moveRight()

Template.ex2.rendered = ->
  # starting page
  Swiper.setPageHard('page1')

  # page control
  Tracker.autorun ->
    if Swiper.pageIs('page1')
        Swiper.leftRight('page3', 'page2')

    else if Swiper.pageIs('page2')
      Swiper.leftRight('page1', 'page3')

    else if Swiper.pageIs('page3')
      Swiper.leftRight('page2', 'page1')
