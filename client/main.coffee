

@pageNames = ->
  [
    'page1'
    'page2'
    'page3'
    'page4'
    'page5'
  ]


Template.slider.rendered = ->

  # hideAll()
  page('page1')

  Tracker.autorun ->

    # With indexes
    # names = pageNames()
    # numPages = names.length
    # center = names.indexOf(getPage())
    # left = wrap(0, numPages-1, center-1)
    # right = wrap(0, numPages-1, center+1)
    # hidden = _.difference([0..numPages-1], [center, right, left])
    # leftCenterRightHide(names[left], names[center], names[right], _.map(hidden, (index) -> names[index]))

    # manually
    # wraps around only one side
    if pageIs('page1')
      leftCenterRightHide(null, 'page1', 'page2', ['page5', 'page3', 'page4'])
    if pageIs('page2')
      leftCenterRightHide('page1', 'page2', 'page3', ['page4', 'page5'])
    if pageIs('page3')
      leftCenterRightHide('page2', 'page3', 'page4', ['page5', 'page1'])
    if pageIs('page4')
      leftCenterRightHide('page3', 'page4', 'page5', ['page1', 'page2'])
    if pageIs('page5')
      leftCenterRightHide('page4', 'page5', 'page1', ['page2', 'page3'])


  # keep track of scrolling
  @startX = 0
  @mouseDown = false
  @mouseX = 0
  @posX = 0
