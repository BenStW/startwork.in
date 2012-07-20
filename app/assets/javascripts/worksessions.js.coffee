# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/




# document needs to be loaded, as parameters are passed from DOM to JS
$(document).ready -> 

   if $("#video_window").length > 0 
      debug = true

      is_work_session = null

      padding = 12	   
      width = $(window).width()-2*padding #200 
      height = $(window).width()-2*padding #200
      if width >300
        width = 300
        height = 300       
      windowProps = 
        width: width
        height: height     
      $("#publisher_box").css("width",width)
      $("#publisher_box").css("height",height)   
      publisher = null
      publisher_hidden = 0   
      
      my_user_id = $('#video_window').data("user_id")
      session_id  = $("#video_window").data("session_id")
      tok_token = $("#video_window").data("tok_token")
      api_key = $("#video_window").data("api_key")
      url = $("#video_window").data("url")
            
      timeout = null
      timer_is_on = 0
      
      start_break_minutes = 55
      start_work_minutes = 5
      #  start_break_minutes = 27
      #  start_work_minutes = 05

      
      calcIsWorkSession = (time)->
        minutes = time.getMinutes()
        if minutes >= start_work_minutes and minutes < start_break_minutes
           true
        else
           false
        
      workSessionDuration = ->
        start_break_minutes - start_work_minutes
      
      
      getCountDownTillNextEvent = (time)->
        minutes = time.getMinutes()
        seconds = time.getSeconds()
      
        if is_work_session
          countdown = start_break_minutes*60 - minutes*60 - seconds
        else
          if minutes < start_work_minutes
            countdown = start_work_minutes*60 - minutes*60 - seconds
          else
            countdown = 60*60 - minutes*60 - seconds + start_work_minutes*60
      
      hidePublisher = ->
        $("#publisher_box").css("width","1px")
        $("#publisher_box").css("height","1px")
        $("#publisher_box").addClass("publisher_hidden")
        publisher_hidden=1    

      
      showPublisher = ->
        $("#publisher_box").removeClass("publisher_hidden")
        publisher_hidden=0
        $("#publisher_box").css("width",width)
        $("#publisher_box").css("height",height)
      
      $("#timer").click ->
        if publisher_hidden
          showPublisher()
        else
          hidePublisher()
      
      
      $("#voice_button").mousedown ->
        $("#voice_button").addClass("btn-danger")
        $("#voice_button").html("Ton an")
        if publisher
           log "mouseDown: publishAudio=true"	
           publisher.publishAudio(true)
      $("#voice_button").mouseup ->
        $("#voice_button").removeClass("btn-danger")
        $("#voice_button").html("Ton aus")
        if publisher
           log "mouseUp: publishAudio=false"		
           publisher.publishAudio(false)
      
      setSoundToBreak = ->
        if publisher
           log "setSoundToBreak: publishAudio=true"
           publisher.publishAudio(true) 
        $("#voice_button_box").hide()
      
      setSoundToWorkSession = ->
        if publisher
           log "setSoundToWorkSession: publishAudio=false"	
           publisher.publishAudio(false) 
        $("#voice_button_box").show()   

      addVideoBox = (user_id, user_name) ->
          html =  "<div id='user_box_"+user_id+"' data-user_id='"+user_id+"'>                      
                      <div class='text_box'>
                        "+user_name+"<br>
                      </div><!-- text_box -->
                      <div  id='streambox_"+user_id+"' class='stream_box'>
                        <div id='stream_box_tmp_"+user_id+"'>
                          <img src='/assets/video_dummy.gif'>
                        </div><!-- stream_box -->
                     </div><!-- stream_box -->		
                  </div> <!-- user_box -->"
          $("#video_window").append(html)
          $("#streambox_"+user_id).css("width",width)
          $("#streambox_"+user_id).css("height",height)


      get_time = ->
        time = ""
        $.ajax
           url: url + '/get_time'
           type: 'GET'
           success: (data) ->
              time = new Date(data)
           async:   false
        time

      subscribeToStreams = (streams) -> 
        log ("subscribeToStreams: subscribe to "+streams.length+" streams")
        for stream in streams
          if stream.connection.connectionId == session.connection.connectionId 
             log ("subscribeToStreams. Same connection. Set the visibility of the publisher to hidden.")
             hidePublisher() 
          else
            connectionData = JSON.parse(stream.connection.data)  
            log "subscribeToStreams: connection.data="
            console.log connectionData       
            user_id = connectionData.user_id
            user_name = connectionData.user_name
            addVideoBox(user_id, user_name)
            replaceElementId = "stream_box_tmp_"+user_id
            log ("subscribeToStreams: replaceElementId = "+replaceElementId)
            session.subscribe stream, replaceElementId, windowProps
              

      
      
      # The Session object dispatches SessionConnectEvent object when a session has successfully connected
      # in response to a call to the connect() method of the Session object. 
      sessionConnectedHandler = (event) ->
        replaceElementId = "publisher_box_tmp"
      
        publishAudio =  if is_work_session then false else true
      
        properties = 
          publishAudio: publishAudio
          width: width
          height: height
        log ("sessionConnectedHandler: publish now with audio="+publishAudio+" at the ID="+replaceElementId)
        publisher = session.publish replaceElementId, properties              
      
        # Subscribe to streams that were in the session when we connected
        subscribeToStreams event.streams 
             
      
      
      #The Session object dispatches StreamEvent events when a session has a stream created or destroyed.
      streamCreatedHandler = (event) -> 
         # Subscribe to any new streams that are created
         subscribeToStreams event.streams
      
      send_exception = (message) ->
        data = 
          message: message
        $.ajax
           url: $("#video_window").data("send_exception_url"),
           data: data,
           type: 'POST'
      
      # Retry session connect
      exceptionHandler = (event) -> 
        log "************* EXCEPTION ************"
        log "exceptionHandler: event.code = "+event.code
        msg = "EventCode: "+event.code+"  "+
              "message: "+event.message+"  "+
              "title: "+event.title+"  "+
              "type: "+event.type
        send_exception(msg)         
        console.log event
        log "************* EXCEPTION ************"
        session.connect api_key, tok_token

#        if (event.code == 1006 || event.code == 1008 || event.code == 1014)
#          alert('There was an error connecting. Trying again.')
#          session.connect api_key, tok_token
      
      
      connectionDestroyedHandler = (event) ->
        connectionsDestroyed = event.connections  
        user_ids = (JSON.parse(connection.data).user_id for connection in connectionsDestroyed)  
        for user_id in user_ids
           $("#user_box_"+user_id).remove()

      
      connectionCreatedHandler = (event) ->
        connectionsCreated = event.connections 
        log ("connectionCreatedHandler:  "+connectionsCreated.length + " connections created")
      
      
      
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
           if s == 0
             log h+":"+m+":"+s+" work_session:"+is_work_session
           prefix_html = if is_work_session then "Arbeitsphase:<br />" else "Pause:<br />"
         #  if !is_work_session and m==5 and s==0
             # location.reload()

           m = m+1 # because no seconds are displayed, 40sec should be 1minute
           html = prefix_html + "noch " + m + " Min"
           $("#timer").html(html)
           f = -> 
              doCount(countdown)
           timeout = setTimeout(f,1000)
         else
           log "doCount: countdown=0. Stop the timer and play the gong."
           stopTimer()
           play_gong()
           log "doCount: countdown=0. Start the timer again."
           startTimer()
      
      
      
      stopTimer = ->
        clearTimeout(timeout)
        timer_is_on=0
      
      mute_audio_for_x_sec = (sec) ->
        if(publisher)
          console.log("publisher already defined")  	
          publisher.publishAudio(false)	
          f = ->
            publishAudio =  if is_work_session then false else true
            publisher.publishAudio(publishAudio)
            clearTimeout(t)
          t = setTimeout(f,sec*1000)
        else
          console.log("publisher not yet defined")      
      
      play_gong = ->
        mute_audio_for_x_sec(8)
        $("#jplayer").jPlayer("play")
      
      
      startTimer = ->
        log "StartTimer: get_time() from Server"
        time = get_time()
        log "StartTimer: time = "+time
        is_work_session = calcIsWorkSession(time)
        log "StartTimer: is_work_session = "+is_work_session
        if is_work_session then setSoundToWorkSession() else setSoundToBreak()
        countdown = getCountDownTillNextEvent(time)
        timer_is_on=1
        doCount(countdown)

      log = (message) ->
        if debug
          d = new Date() 
          console.log d+": "+ message


      startTimer()
      
      TB.setLogLevel(TB.DEBUG) 
      TB.addEventListener 'exception', exceptionHandler

      session = TB.initSession session_id  

      session.addEventListener 'sessionConnected', sessionConnectedHandler #publishes own video
      session.addEventListener 'streamCreated', streamCreatedHandler # shows videos of the others, creates video box
      session.addEventListener 'connectionCreated', connectionCreatedHandler
      session.addEventListener 'connectionDestroyed', connectionDestroyedHandler
      session.connect api_key, tok_token
 
         
      
    
    
    