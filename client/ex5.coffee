
# EXAMPLE 5
# 3 page infinite scrolling but you must press next to transition to the right

Swiper = new Swipe(['page1', 'page2', 'page3'])

Template.ex5.helpers
  Swiper: -> Swiper

Session.setDefault "transitionRightToPage2", false

# If an element controls swiping, make sure to include the `swipe-control` class.
# Then to use the control, use `swipeControl`.
Swiper.swipeControl 'page1', '.next', (e,t) ->
  Session.set "transitionRightToPage2", true

Template.ex5.rendered = ->
  # starting page
  Swiper.setPageHard('page1')

  # page control
  Tracker.autorun ->
    if Session.get "transitionRightToPage2"
      Swiper.setRight('page2')
      Swiper.moveRight()
      Session.set "transitionRightToPage2", false
    else if Swiper.pageIs('page1')
        Swiper.leftRight('page3', null)

    else if Swiper.pageIs('page2')
      Swiper.leftRight('page1', 'page3')

    else if Swiper.pageIs('page3')
      Swiper.leftRight('page2', 'page1')
