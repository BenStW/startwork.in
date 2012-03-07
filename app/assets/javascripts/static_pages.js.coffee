# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready( ->   
  $("#play_jplayer").click ->
    console.log("play jplayer")    
    $("#jplayer").jPlayer("play")
    console.log("jplayer played")

  $("#jplayer").jPlayer(
    ready: -> 
      $(this).jPlayer(
        "setMedia",  
          mp3: "/audios/boxing_bell.mp3",			
          oga: "/audios/boxing_bell.ogg")
    solution: "html,flash", # HTML5 with Flash fallback
    supplied: "mp3, oga",
    swfPath: "/audios/Jplayer.swf"
  )
)

