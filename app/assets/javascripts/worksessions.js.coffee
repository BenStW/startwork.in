# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/




# document needs to be loaded, as parameters are passed from DOM to JS
$(document).ready -> 

  width = 200 
  height = 200	   
  padding = 20




  $('.connect').click (event)-> 
    url = event.target
    doc_width=$(document).width()
    window_width = width + 2*padding
    popup_start = doc_width - width
    window.open(url,
       'StartWork',
       'width='+window_width+',location=no,menubar=no,toolbar=no,scrollbars=yes,resizable=yes,left='+popup_start) 
    false

  
  # only run code when videobox is present
  if $('#video_window').length > 0	   
    my_user_id = $('#video_window').data("user_id")
    TB.setLogLevel(TB.DEBUG) 
    session_id  = $("#video_window").data("session_id")
    tok_token = $("#video_window").data("tok_token")
    api_key = $("#video_window").data("api_key")
    session = TB.initSession session_id  
    toggle = true
    publisher = null
    publisher_hidden = 0

    timeout = null
    timer_is_on = 0

    start_break_minutes = 55
    start_work_minutes = 5

    windowProps = 
      width: width
      height: height

    isWorkSession = ->
      date = new Date()
      minutes = date.getMinutes()
      if minutes >= start_work_minutes and minutes < start_break_minutes
         true
      else
         false

    workSessionDuration = ->
      start_break_minutes - start_work_minutes


    getCountDownTillNextEvent = ->
      date = new Date()
      minutes = date.getMinutes()
      seconds = date.getSeconds()

      if isWorkSession()
        countdown = start_break_minutes*60 - minutes*60 - seconds
      else
        if minutes < start_work_minutes
          countdown = start_work_minutes*60 - minutes*60 - seconds
        else
          countdown = 60*60 - minutes*60 - seconds + start_work_minutes*60

    hidePublisher = ->
      $("#publisher_box").css("visibility", "visible")
      #$("#publisher_box").removeClass("publisher_hidden")
      publisher_hidden=1    

    showPublisher = ->
      $("#publisher_box").css("visibility", "visible")
      #$("#publisher_box").addClass("publisher_hidden")
      publisher_hidden=0

    $("#timer").click ->
      if publisher_hidden
        showPublisher()
      else
        hidePublisher()


    $("#voice_button").mousedown ->
      $("#voice_button").addClass("btn-danger")
      $("#voice_button").html("Ton an")
      if publisher
         console.log "mouseDown: publishAudio=true"	
         publisher.publishAudio(true)
    $("#voice_button").mouseup ->
      $("#voice_button").removeClass("btn-danger")
      $("#voice_button").html("Ton aus")
      if publisher
         console.log "mouseUp: publishAudio=false"		
         publisher.publishAudio(false)

    setSoundToBreak = ->
      if publisher
         console.log "setSoundToBreak: publishAudio=true"
         publisher.publishAudio(true) 
      $("#voice_button_box").hide()

    setSoundToWorkSession = ->
      if publisher
         console.log "setSoundToWorkSession: publishAudio=false"	
         publisher.publishAudio(false) 
      $("#voice_button_box").show()    


    # creates for each new connection a user_box with a text_box and a stream_box
    subscribeToStreams = (streams) -> 
      console.log("subscribe to "+streams.length+" streams")
      for stream in streams
        if stream.connection.connectionId == session.connection.connectionId 
           console.log("   same connection. Set the visibility of the publisher to hidden.")
           hidePublisher()
        else
          connectionData = JSON.parse(stream.connection.data)          
          user_name = connectionData.user_name
          user_id = connectionData.user_id
          console.log("   subscribe to connection of user_id "+user_id+" ("+user_name+")")
          new_element_id = "user_box_" + user_id
          replaceElementId = "stream_box_tmp_"+user_id
          replaceElement = $("#"+replaceElementId)
          #TODO: stream_box may contain already a failing subscriber. Remove it when creating a new stream_box_tmp
          if replaceElement.length==0
            html =  "<div id=stream_box_tmp_"+ user_id + " class=stream_box_tmp>
		     </div><!-- stream_box -->"
            $("#stream_box_"+user_id).append(html)
            console.log("created stream_box_tmp") 
          else
            console.log("no need to create stream_box_tmp")             
          session.subscribe stream, replaceElementId, windowProps
        
  

    postConnectionStart = (user_ids) ->   
      data = 
        user_ids: user_ids
      console.log "connection created. Post to /connection/start: user_ids = "+user_ids
      $.ajax
         url: '/connections/start',
         data: data,
         type: 'POST',
         success: (data) ->
             console.log data  
    
  

    postConnectionEnd = (user_ids) ->           
      data = 
        user_ids: user_ids
      console.log "connection ended. Post to /connection/end: user_ids = "+user_ids
      $.ajax
         url: '/connections/end',
         data: data,
         type: 'POST',
         success: (data) ->
             console.log data
     
 			



    # The Session object dispatches SessionConnectEvent object when a session has successfully connected
    # in response to a call to the connect() method of the Session object. 
    sessionConnectedHandler = (event) ->
      replaceElementId = "publisher_box_tmp"

      publishAudio =  if isWorkSession() then false else true
      console.log "publishAudio = "+publishAudio

      properties = 
        publishAudio: publishAudio
        width: width
        height: height
      publisher = session.publish replaceElementId, properties
            
      # count the number of connections in hidden field
      $("#connectionCountField").val(event.connections.length)
      user_ids = (JSON.parse(connection.data).user_id for connection in event.connections)

      # if more then 1 person is in the work_session, then document the connections 
      if $("#connectionCountField").val()>1        
        postConnectionStart(user_ids)

      console.log("SessionConnectedHandler: number of connections: "+event.connections.length)
      # Subscribe to streams that were in the session when we connected
      subscribeToStreams event.streams 
           
 

    #The Session object dispatches StreamEvent events when a session has a stream created or destroyed.
    streamCreatedHandler = (event) -> 
       # Subscribe to any new streams that are created
       subscribeToStreams event.streams


  

    # Retry session connect
    exceptionHandler = (event) -> 
      if (event.code == 1006 || event.code == 1008 || event.code == 1014)
        alert('There was an error connecting. Trying again.')
        session.connect api_key, tok_token


 

    connectionDestroyedHandler = (event) ->
      connectionsDestroyed = event.connections  
      origConnectionsCount = parseInt($("#connectionCountField").val())
      connectionsCount = origConnectionsCount - connectionsDestroyed.length
      $("#connectionCountField").val(connectionsCount)

      user_ids = (JSON.parse(connection.data).user_id for connection in connectionsDestroyed)  
      console.log("The number of connections changed from "+origConnectionsCount+ " to "+connectionsCount+". Lost user ids: "+user_ids)

      # if user is left alone, also end his connection
      if connectionsCount == 1
         user_ids.push(my_user_id)
      postConnectionEnd(user_ids)    

 
 

    connectionCreatedHandler = (event) ->
      connectionsCreated = event.connections 

      origConnectionsCount = parseInt($("#connectionCountField").val())
      connectionsCount = origConnectionsCount + connectionsCreated.length
      $("#connectionCountField").val(connectionsCount)	
	 
      user_ids = (JSON.parse(connection.data).user_id for connection in connectionsCreated)
      console.log("The number of connections changed from "+origConnectionsCount+ " to "+connectionsCount+". New user ids: "+user_ids)

      # Add the own user_id , because the server tracks only video learning with 2 or more people
      # When the 2nd person connects, all browsers will send the new connections including the own user_id  
      user_ids.push(my_user_id)
      postConnectionStart(user_ids)

  
  

    #  ************* Timer functions *********************

    
    $("#jplayer").jPlayer(
    # downloaded from http://www.freesound.org/people/Benboncan/sounds/66951/	
      ready: -> 
        $(this).jPlayer(
          "setMedia",  
            mp3: "/audios/boxing-bell.mp3",			
            oga: "/audios/boxing-bell.ogg")
      solution: "html,flash", # HTML5 with Flash fallback
      supplied: "mp3, oga",
      swfPath: "/audios/Jplayer.swf")
    
    $("#ben").click ->
      play_gong()


    leadingzero = (number) ->
       if number < 10
         '0' + number
       else
          number
    
    doCount = (countdown, work_session_boolean) ->
      if (countdown > 0)
	     
         countdown--
         h = Math.floor(countdown/3600)
         m = Math.floor((countdown - (h * 3600))/60)
         s = (countdown-(h*3600))%60
         #console.log h+":"+m+":"+s+" work_session:"+work_session_boolean
         prefix_html = if work_session_boolean then "Arbeitsphase:<br />" else "Pause:<br />"
         m = m+1 # because no seconds are displayed, 40sec should be 1minute
         html = prefix_html + "noch " + m + " Min"
      	 # "+leadingzero(h) + ':' +
           # + ':' + leadingzero(s)
         $("#timer").html(html)
         f = -> 
            doCount(countdown, work_session_boolean)
         timeout = setTimeout(f,1000)
       else
         stopTimer()
         play_gong()
         startTimer()


    
    stopTimer = ->
      clearTimeout(timeout)
      timer_is_on=0

    mute_audio_for_x_sec = (sec) ->
      if(publisher)
        console.log("publisher already defined")  	
        publisher.publishAudio(false)	
        f = ->
          publisher.publishAudio(true)
          clearTimeout(t)
        t = setTimeout(f,sec*1000)
      else
        console.log("publisher not yet defined")      

    play_gong = ->
      mute_audio_for_x_sec(8)
      $("#jplayer").jPlayer("play")


    # can be deleted
    play_sound = (sound) ->
      console.log("play_sound was called")
      if (window.HTMLAudioElement) 
        snd = new Audio('')
        if(snd.canPlayType('audio/wav'))
	      # TODO: publish may not be defined yet
          publisher.publishAudio(false)
          snd = new Audio(sound)
          snd.play()
          f = ->
            publisher.publishAudio(true)
            clearTimeout(t)
          #t = setTimeout(f,8000)
        else
          alert('GONG!!! - HTML5 Audio is not supported by your browser!')
      
    
    
    startTimer = ->
    # date = new Date()
    # minutes = date.getMinutes()
    # seconds = date.getSeconds()
    #
    # # if time is below 50 minutes, then we are in the 50 minutes work session, else in the 10 min pause   
    # work_session_duration=50

      is_work_session = isWorkSession() 
      if is_work_session then setSoundToWorkSession() else setSoundToBreak()
      countdown = getCountDownTillNextEvent()
      timer_is_on=1
      doCount(countdown,is_work_session )
      
    # session_duration = if minutes<work_session_duration then work_session_duration*60 else (60 - work_session_duration) *60         
    # time_to_full_hour =  60*60 - minutes*60 - seconds
    # countdown = if minutes<work_session_duration then time_to_full_hour - (60-work_session_duration)*60 else time_to_full_hour

    
    if $("#timer").length>0   
      startTimer()
    
    
    
    
    session.addEventListener 'sessionConnected', sessionConnectedHandler
    session.addEventListener 'streamCreated', streamCreatedHandler
   # session.addEventListener 'signalReceived', signalReceivedHandler
    session.addEventListener 'connectionCreated', connectionCreatedHandler
    session.addEventListener 'connectionDestroyed', connectionDestroyedHandler
    TB.addEventListener 'exception', exceptionHandler
    session.connect api_key, tok_token




