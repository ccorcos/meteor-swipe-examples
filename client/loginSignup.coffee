

loginOrSignup = (username, password, callback)->
  Meteor.loginWithPassword username, password,
    (err) ->
      if err
        if err.reason is "User not found"
          signup(username, password, callback)
        else
          errorMsg err.reason
      else
        callback?()

signup = (username, password, callback)->
  Accounts.createUser
    username: username
    password: password
  ,
    (err) ->
      if err
        errorMsg  err.reason
      else
        callback?()



Template.loginSignup.events
  'keyup #username': (e,t) ->
    if e.keyCode is 13
      $('#username').blur()
      $('#password').focus()
  'keyup #password': (e,t) ->
    if e.keyCode is 13
      $('#password').blur()
      username = t.find('#username').value
      password = t.find('#password').value
      if username.length > 0 and password.length > 0
        loginOrSignup username, password, afterLoginSignup
  'click #loginSignup': (e,t) ->
    username = t.find('#username').value
    password = t.find('#password').value
    if username.length > 0 and password.length > 0
      loginOrSignup username, password, afterLoginSignup
