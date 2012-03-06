# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready( ->   
  $("#ben1").click ->
    $.fn.soundPlay(
      url: '/audios/boxing-bell.wav',
      playerId: 'embed_player', 
      command: 'play')	)