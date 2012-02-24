# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->

    leadingzero = (number) ->
       if number < 10
         '0' + number
       else
          number

    doCount = (countdown) ->
      if (countdown > 0)
         countdown--
         h = Math.floor(countdown/3600)
         m = Math.floor((countdown - (h * 3600))/60)
         s = (countdown-(h*3600))%60
         html =
           leadingzero(h) + ':' +
           leadingzero(m) + ':' +
           leadingzero(s)
         
         $("#timer_box").html(html)
         f = -> 
            doCount(countdown)
         window.setTimeout(f,1000)
       else
         alert "countdown over!"
    doCount(50*60)
