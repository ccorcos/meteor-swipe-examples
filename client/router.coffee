Session.setDefault "loginRedirect", 'page1'

# Router is just handling urls and login redirecting. Make sure not to do anything
# with Swiper in the `before` function or you might end up in reactive hell.

Router.map ->
  @route 'loginSignup',
    template: 'main'
    before: ->
      console.log "router loginSignup"
      if Meteor.loggingIn() or Meteor.user()
        this.redirect 'page1'
      this.next()

  @route 'page1',
    template: 'main'
    path: '/'
    before: ->
      console.log "router page1"
      if (not Meteor.loggingIn()) and (not Meteor.user())
        Session.set 'loginRedirect', 'page1'
        this.redirect('loginSignup')
      this.next()

  @route 'page2',
    template: 'main'
    before: ->
      console.log "router page2"
      if (not Meteor.loggingIn()) and (not Meteor.user())
        Session.set 'loginRedirect', 'page2'
        this.redirect('loginSignup')
      this.next()


  @route 'page3',
    template: 'main'
    before: ->
      console.log "router page3"
      if (not Meteor.loggingIn()) and (not Meteor.user())
        Session.set 'loginRedirect', 'page3'
        this.redirect('loginSignup')
      this.next()


Router.configure
  layoutTemplate: 'layout'
