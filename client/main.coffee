# This car


@pageNames = ->
  [
    'page1'
    'page2'
    'page3'
    'page4'
    'page5'
  ]


Template.slider.rendered = ->

  page('page1')

  names = pageNames()

  firstTime = true
  Tracker.autorun ->
    # Don't animate the first time!
    if firstTime
      firstTime = false
    else
      for name in names
        $('.page.'+name).addClass('animate')


    # With indexes
    numPages = names.length
    center = names.indexOf(getPage())
    left = wrap(0, numPages-1, center-1)
    right = wrap(0, numPages-1, center+1)
    hidden = _.difference([0..numPages-1], [center, right, left])
    leftCenterRightHide(names[left], names[center], names[right], _.map(hidden, (index) -> names[index]))

    # manually
    # if pageIs('page1')
    #   leftCenterRightHide('page5', 'page1', 'page2', ['page3', 'page4'])
    # if pageIs('page1')
    #   leftCenterRightHide('page5', 'page1', 'page2', ['page3', 'page4'])
    # if pageIs('page1')
    #   leftCenterRightHide('page5', 'page1', 'page2', ['page3', 'page4'])
    # if pageIs('page1')
    #   leftCenterRightHide('page5', 'page1', 'page2', ['page3', 'page4'])
    # if pageIs('page1')
    #   leftCenterRightHide('page5', 'page1', 'page2', ['page3', 'page4'])


  # keep track of scrolling
  @startX = 0
  @mouseDown = false
  @mouseX = 0
  @posX = 0
