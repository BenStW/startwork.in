# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready -> 
  if $('#jplayer').length > 0  
    $("#play_jplayer").click ->
      console.log("play jplayer")    
      $("#jplayer").jPlayer("play")
      console.log("jplayer played")
    
    $("#jplayer").jPlayer(
      ready: -> 
        $(this).jPlayer(
          "setMedia",  
            mp3: "http://fierce-ice-1470.herokuapp.com/audios/boxing-bell.mp3",			
            oga: "http://fierce-ice-1470.herokuapp.com/audios/boxing-bell.ogg")
      solution: "html,flash", # HTML5 with Flash fallback
      supplied: "mp3, oga",
      swfPath: "http://fierce-ice-1470.herokuapp.com/audios/Jplayer.swf")


