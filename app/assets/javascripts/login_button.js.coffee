$(document).ready ->

  if $("#login_button").length>0
    showConnecting = ()->
       $("#login_button").html("verbinde")
    
    dot_sec=1
    addDot = ()->
       $("#login_button").append(".")
       modulo = dot_sec % 4
       if modulo==0
         showConnecting()
       dot_sec = dot_sec + 1
    
    $("#login_button").click (event )->
      showConnecting()
      setInterval(addDot,1000)
