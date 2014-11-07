if false
  # EXAMPLE 3
  # This example shows how you can dynamically set the center, left and right pages
  # to whatever you want with no deterimental effects. In this example, we set out
  # to show:
  #
  # 1) We can prevent a swipe in either direction by setting null
  # 2) We can infinitely swipe in circles if we want (to the right in this case)
  # 3) We can have pages drop out seemlessly as happens with page5 after being viewed


  Swiper = new Swipe(['page1', 'page2', 'page3', 'page4', 'page5'])

  Template.ex3.helpers
    Swiper: -> Swiper

  # If an element controls swiping, make sure to include the `swipe-control` class.
  # Then to use the control, use `swipeControl`.
  swipeControl Swiper, 'page1', '.next', (e,t) ->
    Swiper.moveRight()

  Template.ex3.rendered = ->

    # starting page
    Swiper.setPage('page1')

    # page control
    removePage5 = false
    Tracker.autorun ->
      if Swiper.pageIs('page1')
        if removePage5
          Swiper.leftRight('page4', 'page2')
        else
          Swiper.leftRight(null, 'page2')

      else if Swiper.pageIs('page2')
        Swiper.leftRight('page1', 'page3')

      else if Swiper.pageIs('page3')
        Swiper.leftRight('page2', 'page4')

      else if Swiper.pageIs('page4')
        if removePage5
          Swiper.leftRight('page3', 'page1')
        else
          Swiper.leftRight('page3', 'page5')

      else if Swiper.pageIs('page5')
        removePage5 = true
        Swiper.leftRight('page4', 'page1')
