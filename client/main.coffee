
@Swiper = new Swipe(['loginSignup', 'page1', 'page2', 'page3'])

Template.main.helpers
  Swiper: -> Swiper

# If an element controls swiping, make sure to include the `swipe-control` class.
# Then to use the control, use `swipeControl`.
# Swiper.swipeControl 'page1', '.next', (e,t) ->
#   Swiper.moveRight()

Template.main.rendered = ->
  # set the initial page
  Swiper.setPage Router.current().route.getName()

  # page control
  Tracker.autorun ->
    if Swiper.pageIs('loginSignup')
      Swiper.leftRight(null, null)

    else if Swiper.pageIs('page1')
      Swiper.leftRight('page3', 'page2')

    else if Swiper.pageIs('page2')
      Swiper.leftRight('page1', 'page3')

    else if Swiper.pageIs('page3')
      Swiper.leftRight('page2', 'page1')
