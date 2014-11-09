
# Initialize the Swiper
@Swiper = new Swipe(['loginSignup', 'page1', 'page2', 'page3'])

Template.main.helpers
  Swiper: -> Swiper


Template.main.rendered = ->
  # set the initial page from the route
  Swiper.setPage Router.current().route.getName()

  # page control
  Tracker.autorun ->
    # small problem right now: this autorun runs too many times
    console.log "autorun"

    # Animate the transitions
    if Session.get "logoutTransition"
      Swiper.setLeft "loginSignup"
      Swiper.moveLeft()
      Session.set "logoutTransition", false

    else if Session.get "loginTransition"
      Swiper.setRight Session.get('loginRedirect')
      Swiper.moveRight()
      Session.set "loginTransition", false

    # Set the left and right for swiping and set the route as they change
    else if Swiper.pageIs('loginSignup')
      Router.go "loginSignup"
      Swiper.leftRight(null, null)

    else if Swiper.pageIs('page1')
      Router.go "page1"
      Swiper.leftRight('page3', 'page2')

    else if Swiper.pageIs('page2')
      Router.go "page2"
      Swiper.leftRight('page1', 'page3')

    else if Swiper.pageIs('page3')
      Router.go "page3"
      Swiper.leftRight('page2', 'page1')

@afterLoginSignup = () ->
  Session.set "loginTransition", true

Template.page1.events
  'click .logout': (e,t) ->
    Meteor.logout()
    Session.set "logoutTransition", true

# If an element controls swiping, make sure to include the `swipe-control` class.
# Then to use the control, use `swipeControl`.
Swiper.swipeControl 'page2', '.next', (e,t) ->
  Swiper.moveRight()
