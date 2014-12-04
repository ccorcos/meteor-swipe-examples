
# Initialize the Swiper
@Swiper = new Swipe(['page1', 'page2', 'page3', 'page4', 'page5'])

Template.main.helpers
  Swiper: -> Swiper

# If an element controls swiping, make sure to include the `swipe-control` class.
# Then to use the control, use `swipeControl`.
Swiper.click 'page1', '.next', (e,t) ->
  Swiper.moveRight()

Swiper.click 'page2', '.big-right', (e,t) ->
  Swiper.moveRight()

Swiper.click 'page2', '.custom-transition', (e,t) ->
  Swiper.transitionRight 'page5'

Swiper.click 'page5', '.left-to-page4', (e,t) ->
  Swiper.transitionLeft 'page4'

Swiper.click 'page5', '.right-to-page1', (e,t) ->
  Swiper.transitionRight 'page1'

Swiper.click 'page1', '.pop-up', (e,t) ->
  alert 'you cant swipe on this page. only transition left and right and see a pop up.'




Template.main.rendered = ->

  # starting page
  Swiper.setInitialPage 'page1'

  # initially, you cant swipe left. but once you go around the loop, page4 drops
  # off. This tests to see that the animation completes and page4 doesnt disappear
  # before it is done animating.

  # once page4 drops off, we have 3 pages. We can scroll through these fast to make
  # sure that the pages wrap around without animating in front of us.

  # scroll check
  # buttton check and button with swipe check
  # no swipe check
  # scroll check

  removePage4 = false
  Tracker.autorun ->
    if Swiper.pageIs('page1')
      if removePage4
        Swiper.leftRight('page3', 'page2')
      else
        Swiper.leftRight(null, 'page2')

  Tracker.autorun ->
    if Swiper.pageIs('page2')
      Swiper.leftRight('page1', 'page3')

  Tracker.autorun ->
    if Swiper.pageIs('page3')
      if removePage4
        Swiper.leftRight('page2', 'page1')
      else
        Swiper.leftRight('page2', 'page4')

  Tracker.autorun ->
    if Swiper.pageIs('page4')
      removePage4 = true
      Swiper.leftRight('page3', 'page1')

  Tracker.autorun ->
    if Swiper.pageIs('page5')
      console.log "page5"
      # you're stuck here. must use a control!
      Swiper.leftRight(null, null)
