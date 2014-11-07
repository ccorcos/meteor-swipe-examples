
if false

  # EXAMPLE1
  #
  # Simple scrolling left to right

  Swiper = new Swipe(['page1', 'page2', 'page3', 'page4', 'page5'])

  Template.ex1.helpers
    Swiper: -> Swiper

  # If an element controls swiping, make sure to include the `swipe-control` class.
  # Then to use the control, use `swipeControl`.
  swipeControl Swiper, 'page1', '.next', (e,t) ->
    Swiper.moveRight()

  Template.ex1.rendered = ->

    # starting page
    Swiper.setPage('page1')

    # page control
    Tracker.autorun ->
      if Swiper.pageIs('page1')
        Swiper.leftRight(null, 'page2')

      else if Swiper.pageIs('page2')
        Swiper.leftRight('page1', 'page3')

      else if Swiper.pageIs('page3')
        Swiper.leftRight('page2', 'page4')

      else if Swiper.pageIs('page4')
          Swiper.leftRight('page3', 'page5')

      else if Swiper.pageIs('page5')
        Swiper.leftRight('page4', null)
