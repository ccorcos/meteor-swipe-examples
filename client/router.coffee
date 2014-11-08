Swiper = @Swiper

@subs = new SubsManager()

Session.setDefault 'listId', null

Router.map ->
  @route 'lists',
    template: 'main'
    path: '/'
    waitOn: ->
      subs.subscribe('lists')
    onBeforeAction: ->
      if Meteor.user()
        Swiper.setPage('lists')
      else
        this.redirect('loginSignup')
      this.next()

  @route 'tasks',
    template: 'main'
    path: '/:_id'
    waitOn: ->
      subs.subscribe('tasks', @params._id)
    onBeforeAction: ->
      if Meteor.user()
        Session.set 'listId', @params._id
        Swiper.setPage('tasks')
      else
        this.redirect('loginSignup')
      this.next()

  @route 'loginSignup',
    template: 'main'
    onBeforeAction: ->
      if Meteor.user()
        this.redirect('lists')
      else
        Swiper.setPage('loginSignup')
      this.next()


Router.configure
  layoutTemplate: 'layout'
