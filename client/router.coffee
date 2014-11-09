Session.setDefault "loginRedirect", 'page1'

# `main` gets rendered after the router get called. Thus the Swiper isnt tied
# to an existing template yet. So we have to call `Swiper.setPage` in the rendered
# function

Router.map ->
  @route 'loginSignup',
    template: 'main'
    onBeforeAction: ->
      if Meteor.user()
        this.redirect Session.get('loginRedirect')
      else
        if Swiper.isReady() then Swiper.setPage('loginSignup')
      this.next()

  @route 'page1',
    template: 'main'
    path: '/'
    onBeforeAction: ->
      if Meteor.user()
        if Swiper.isReady() then Swiper.setPage('page1')
      else
        Session.set 'loginRedirect', 'page1'
        this.redirect('loginSignup')
      this.next()

  @route 'page2',
    template: 'main'
    onBeforeAction: ->
      if Meteor.user()
        if Swiper.isReady() then Swiper.setPage('page2')
      else
        Session.set 'loginRedirect', 'page2'
        this.redirect('loginSignup')
      this.next()

  @route 'page3',
    template: 'main'
    onBeforeAction: ->
      if Meteor.user()
        if Swiper.isReady() then Swiper.setPage('page3')
      else
        Session.set 'loginRedirect', 'page3'
        this.redirect('loginSignup')
      this.next()

Router.configure
  layoutTemplate: 'layout'
