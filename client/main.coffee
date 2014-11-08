
@Swiper = new Swipe(['loginSignup', 'lists', 'tasks'])

for page in ['loginSignup', 'lists', 'tasks']
  console.log Template[page].events

Template.main.helpers
  Swiper: -> Swiper

# If an element controls swiping, make sure to include the `swipe-control` class.
# Then to use the control, use `swipeControl`.
Swiper.swipeControl 'page1', '.next', (e,t) ->
  Swiper.moveRight()

Template.main.rendered = ->

  # starting page
  Swiper.setPage('page1')

  # if not logged in, set route to login
  # else

  # page control
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
