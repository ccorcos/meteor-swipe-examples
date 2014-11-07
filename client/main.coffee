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

  removePage5 = false

  Tracker.autorun ->

    # With indexes
    # numPages = names.length
    # center = names.indexOf(getPage())
    # left = wrap(0, numPages-1, center-1)
    # right = wrap(0, numPages-1, center+1)
    # hidden = _.difference([0..numPages-1], [center, right, left])
    # leftCenterRightHide(names[left], names[center], names[right], _.map(hidden, (index) -> names[index]))

    # manually
    if pageIs('page1')
      # leftCenterRightHide(null, 'page1', 'page2', ['page3', 'page4', 'page5'])
      if removePage5
        # $('.page.page5').css 'z-index', '0'
        # $('.page.page1').css 'z-index', '1'
        leftCenterRightHide('page4', 'page1', 'page2', ['page3'])
      else
        leftCenterRightHide(null, 'page1', 'page2', ['page3', 'page4', 'page5'])
    if pageIs('page2')
      leftCenterRightHide('page1', 'page2', 'page3', ['page4', 'page5'])
    if pageIs('page3')
      leftCenterRightHide('page2', 'page3', 'page4', ['page5', 'page1'])
    if pageIs('page4')
      if removePage5
        leftCenterRightHide('page3', 'page4', 'page1', ['page5', 'page2'])
      else
        leftCenterRightHide('page3', 'page4', 'page5', ['page1', 'page2'])
    if pageIs('page5')
      removePage5 = true
      leftCenterRightHide('page4', 'page5', 'page1', ['page2', 'page3'])


  # keep track of scrolling
  @startX = 0
  @mouseDown = false
  @mouseX = 0
  @posX = 0
