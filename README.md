# Swipe Examples

This repo contains some examples of the [ccorcos:swipe](https://github.com/ccorcos/meteor-swipe/) package.

## Tests

This [demo](swiper.meteor.com) shows a bunch of edge cases to test:

- page ordering

    several `autorun`s used to manage pages. Cannot scroll in a direction
    when passed null. EX: initially, on the first page, you cant scroll left.

- 3 pages circular swipe

    after you scroll around once, you end up with 3 pages
    and notice that they dont overlap on each other when they wrap
    to the other side

- drop page after transition

    when you get to page4, it will no longer be available after you swipe
    away from it. This tests to see if it finishes animating smoothly and you
    never see the red background

- no swiping from element

    using the 'no-swipe' class, we create a block from where swiping doesnt work

- vertical scrolling

    using the 'scrollable' class, we create page that is scrollable
    make sure you can still swipe or scroll nicely

- click

    `Swipe.click` allows you to register the touch / click events appropriately.
    notice how swiping on top of them doesnt work. and dragging with them is also
    handled in an expected way.

- swipe control

    using the 'swipe-control' class and the `click` function, we
    can register events that move the pages or transition or move one
    way or the other

- transition to a page that doesnt exist

    on page2, you can execute a custom transition to page that doesnt exist.
    you'll be locked in and will have to click a button to pop out. You can 
    animate transition to any page with `transitionRight` or `transitionLeft`



## To do
- keep session variables after reload
- mouse off screen bug
