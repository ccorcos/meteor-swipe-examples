
# Initialize the Swiper
Swiper = new Swipe(['page1', 'page2', 'page3', 'page4', 'page5'])

Template.main.helpers
  Swiper: -> Swiper



# If an element controls swiping, make sure to include the `swipe-control` class.
# Then to use the control, use `swipeControl`.
Swiper.swipeControl 'page1', '.next', (e,t) ->
  Swiper.moveRight()

Swiper.swipeControl 'page2', '.big-right', (e,t) ->
  Swiper.moveRight()

Template.main.rendered = ->

  # starting page
  Swiper.setPageHard('page1')

  # page control
  Tracker.autorun ->
    # small problem right now: this autorun runs too many times
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
