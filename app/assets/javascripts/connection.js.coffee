# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  timeout = null
  timer_is_on = 0
  
  
  leadingzero = (number) ->
     if number < 10
       '0' + number
     else
        number
  
  doCount = (div_id,countdown, work_session_boolean) ->
    if (countdown > 0)
       countdown--
       h = Math.floor(countdown/3600)
       m = Math.floor((countdown - (h * 3600))/60)
       s = (countdown-(h*3600))%60
       prefix_html = if work_session_boolean then "Arbeitsphase: " else "Pause: "
       html =
         ""+prefix_html + "Noch "+m+" Min"
		 # "+leadingzero(h) + ':' +
         # + ':' + leadingzero(s)
       
       $(div_id).html(html)
       f = -> 
          doCount(div_id,countdown, work_session_boolean)
       timeout = setTimeout(f,1000)
     else
       stopTimer()
       # downloaded from http://www.freesound.org/people/Benboncan/sounds/66951/
       play_sound('/audios/boxing-bell.wav')
       startTimer()

  stopTimer = ->
    clearTimeout(timeout)
    timer_is_on=0

  play_sound = (sound) ->
    if (window.HTMLAudioElement) 
      snd = new Audio('')
      if(snd.canPlayType('audio/wav'))
        snd = new Audio(sound)
        snd.play()
      else
        alert('GONG!!! - HTML5 Audio is not supported by your browser!')


  startTimer = (div_id)->
    date = new Date()
    minutes = date.getMinutes()
    seconds = date.getSeconds()
    # if time is below 50 minutes, then we are in the 50 minutes work session, else in the 10 min pause   
    work_session_duration=50
    session_duration = if minutes<work_session_duration then work_session_duration*60 else (60 - work_session_duration) *60         
    time_to_full_hour =  60*60 - minutes*60 - seconds
    countdown = if minutes<work_session_duration then time_to_full_hour - (60-work_session_duration)*60 else time_to_full_hour
    timer_is_on=1
    doCount(div_id,countdown,minutes<work_session_duration )  

  if $("#timer_box").length>0   
    startTimer("#timer_box")
