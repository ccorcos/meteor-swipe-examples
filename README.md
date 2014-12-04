# Swipe Examples

This repo contains some examples of the [ccorcos:swipe](https://github.com/ccorcos/meteor-swipe/
) package.
<!--
## Demos

You can see the code in the corresponding branches. Each example is deployed to the links below

- [ex1](http://swipe-ex1.meteor.com/)
- [ex2](http://swipe-ex2.meteor.com/)
- [ex3](http://swipe-ex3.meteor.com/)
- [ex4](http://swipe-ex4.meteor.com/) -->


## Tests

This demo shows a bunch of edge cases to test:

- page ordering

    several `autorun`s used to manage pages. Cannot scroll in a direction
    when passed null

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


## To do

- create page an transition on trigger
- and touch/control buttons in general
- iron router integration
- change url without triggering actions



- keep session variables after reload
- mouse off screen bug
