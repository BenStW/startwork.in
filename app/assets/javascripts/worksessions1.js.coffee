# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/




# document needs to be loaded, as parameters are passed from DOM to JS
$(document).ready -> 

  width = parseInt($("#size").data("stream_width"))    
  height = parseInt($("#size").data("stream_height"))	   
  padding = parseInt($("#size").data("stream_padding")) 


  $('.connect').click (event)-> 
    url = event.target
    doc_width=$(document).width()
    window_width = 2 * width + padding
    window_height = 5 * height + 10 * padding
    popup_start = doc_width - width
    window.open(url,
       'StartWork',
       'width='+window_width+',height='+window_height+',location=no,menubar=no,toolbar=no,scrollbars=yes,resizable=yes,left='+popup_start) 
    false

  
  # only run code when videobox is present
  if $('#video_window').length > 0	   
    my_user_id = $('#video_window').data("user_id")
    penalty_id=-1
    warning_count_down_timer = null 
    warning_count_down_timer_is_on = 0
    penalty_count_up_timer = null 
    penalty_count_up_timer_is_on = 0
    TB.setLogLevel(TB.DEBUG) 
    session_id  = $("#video_window").data("session_id")
    tok_token = $("#video_window").data("tok_token")
    api_key = $("#video_window").data("api_key")
    session = TB.initSession session_id  
    toggle = true
    publisher = null

    timeout = null
    timer_is_on = 0

    windowProps = 
      width: width
      height: height

    $("#user_exists").click ->
      user_id=$("#user_exists").val()
      element_id = "user_box_" + user_id
      e = $("#"+element_id).length>0
      msg = element_id+ " exists? "+e
      console.log(msg)


    # creates for each new connection a user_box with a text_box and a stream_box
    subscribeToStreams = (streams) -> 
      console.log("subscribe to "+streams.length+" streams")      
      for stream in streams
        if stream.connection.connectionId == session.connection.connectionId 
          console.log("   same connection. Don't subscribe")
        else
          connectionData = JSON.parse(stream.connection.data)          
          user_name = connectionData.user_name
          user_id = connectionData.user_id
          console.log("   subscribe to connection of user_id "+user_id+" ("+user_name+")")
          new_element_id = "user_box_" + user_id
          if $("#"+new_element_id).length>0
             console.log("ERROR: "+ new_element_id+ " exists already")
             console.log($("#"+new_element_id).html())
          else
            replaceElementId = "stream_box_tmp_"+user_id
            html = 
              "<div id="+new_element_id+" class=user_box data-user_id="+user_id+">
                 <div class=text_box>
                   <b>"+user_name+"</b><br>
                 </div><!-- text_box -->
                 <div class=stream_box>
                   <div id="+replaceElementId+" class=stream_box_tmp>
                      stream"+user_id+"
                   </div><!-- stream_box -->
                 </div><!-- stream_box -->		
               </div> <!-- user_box -->"
            $("#video_window").append(html)
            bind_penalty_forms()
            session.subscribe stream, replaceElementId, windowProps
        



    # Gets the latest chat entry from the database given somebodys connectionId
    getPenalty = (connection) -> 
       $.ajax
          url: '/penalties/latest',
          success: (data) ->
             penalty_id = data.penalty_id
             to_user_name = data.to_user_name
             from_user_name = data.from_user_name
             to_user_id = data.to_user_id
             from_user_id = data.from_user_id
             msg = "P by "+ from_user_name+"<br>"
             $("#user_box_"+to_user_id+" .text_box").append(msg)
             if to_user_id == my_user_id
               receivedPenalty()



    receivedPenalty = ->
      console.log "my user_id "+my_user_id+" received a penalty "+penalty_id+". Start penalty process"
      start_penalty_process()



    postCancelPenalty =  ->
       console.log "post cancel penalty of penalty "+penalty_id
       data = {}
       $.ajax
         url: '/penalties/cancel/'+penalty_id,
         data: data,
         type: 'POST',
         success: (data) ->
            # Signal to other clients that we have inserted new data
            # session.signal()
   
  

    postEndPenalty = (excuse) ->
       console.log "post end penalty of penalty "+penalty_id
       data = 
         excuse: excuse
       $.ajax
         url: '/penalties/end/'+penalty_id,
         data: data,
         type: 'POST',
         success: (data) ->
            # Signal to other clients that we have inserted new data
            # session.signal()
  
  

    postPenalty = (from_user_id, to_user_id) ->
       data = 
         from_user_id: from_user_id,
         to_user_id: to_user_id
       $.ajax
         url: '/penalties/add',
         data: data,
         type: 'POST',
         success: (data) ->
            # Signal to other clients that we have inserted new data
            session.signal()
    
   

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
     
  

    bind_penalty_forms = ->
      $(".stream_boxXXX").click (event)-> 
        date = new Date()
        minutes = date.getMinutes()
        if minutes<50
          penalty_user_id = $(this).parent(".user_box").data("user_id")
          if my_user_id != penalty_user_id
            postPenalty my_user_id, penalty_user_id				



    # The Session object dispatches SessionConnectEvent object when a session has successfully connected
    # in response to a call to the connect() method of the Session object. 
    sessionConnectedHandler = (event) ->
      replaceElementId = "publisher_box_tmp"
      publisher = session.publish replaceElementId, windowProps
      
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

 

    signalReceivedHandler = (event) ->  
      #getChatEntry(event.fromConnection.connectionId)
      getPenalty(event.fromConnection)

 

    connectionDestroyedHandler = (event) ->
      connectionsDestroyed = event.connections  
      origConnectionsCount = parseInt($("#connectionCountField").val())
      connectionsCount = origConnectionsCount - connectionsDestroyed.length
      $("#connectionCountField").val(connectionsCount)

      user_ids = (JSON.parse(connection.data).user_id for connection in connectionsDestroyed)  
      console.log("The number of connections changed from "+origConnectionsCount+ " to "+connectionsCount+". Lost user ids: "+user_ids)

      # remove the user boxes of the lost connections 
      $("#user_box_"+user_id).remove() for user_id in user_ids 

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

  
    # ***************** Penalty process ***********************

    leadingzero = (number) ->
      if number < 10
        '0' + number
      else
        number
  


    do_warning_count_down = (count_down) ->
      if count_down>0
        count_down--
        html = leadingzero(count_down)
        $("#warning_count_down_timer").html(html)
        f = -> 
          do_warning_count_down(count_down)
        warning_count_down_timer = setTimeout(f,1000)
      else
        stop_warning_count_down()
        $( "#warning_count_down_window" ).dialog( "close" )
        if !penalty_count_up_timer_is_on
          $("#penalty_count_up_window").dialog("open")
          penalty_count_up_timer_is_on=1
          # empty the form 
          $("#excuse").val("")
          date = new Date()
          minutes = date.getMinutes()
          seconds = date.getSeconds()
          time_to_full_hour =  60*60 - minutes*60 - seconds
          pause = 10*60
          countdown = time_to_full_hour - pause
          do_penalty_count_up(10,countdown)
        else
          alert "ERROR: penalty_count_up_timer is still on!"
  


    do_penalty_count_up = (count_up,limit) ->
      if count_up<limit
        count_up++
        h = Math.floor(count_up/3600)
        m = Math.floor((count_up - (h * 3600))/60)
        s = (count_up-(h*3600))%60
        html =
          leadingzero(h) + ':' +
          leadingzero(m) + ':' +
          leadingzero(s)
        $("#penalty_count_up_timer").html(html)
        f = -> 
          do_penalty_count_up(count_up,limit)
        warning_count_down_timer = setTimeout(f,1000)
      else
        stop_penalty_count_up()
  


    stop_warning_count_down = ->
      clearTimeout(warning_count_down_timer)
      warning_count_down_timer_is_on=0
  


    $( "#warning_count_down_window" ).dialog(
      autoOpen: false
      height: 200
      width: 240
      modal: true
      beforeClose: ->
        if warning_count_down_timer_is_on
          stop_warning_count_down()
          postCancelPenalty() )
 

 
    start_penalty_process = ->
      if !warning_count_down_timer_is_on
        $( "#warning_count_down_window" ).dialog( "open" )
        warning_count_down_timer_is_on=1
        do_warning_count_down(10)
      else
        alert "ERROR: warning count down timer is still on"
  

  
    stop_penalty_count_up = ->
      clearTimeout(penalty_count_up_timer)
      penalty_count_up_timer_is_on=0
  
 

    $( "#penalty_count_up_window" ).dialog(
      autoOpen: false
      height: 300
      width: 240
      modal: true
      beforeClose: ->
        excuse = $("#excuse").val()
        if excuse
          true
        else
          alert "Please fill out an excuse" 
          false
      close: ->
        stop_penalty_count_up()
        excuse = $("#excuse").val()
        if excuse
          postEndPenalty(excuse)
        else
          alert "ERROR: no message given"
      buttons: "Send Excuse": ->
        $(this).dialog("close"))
  

    #  ************* Timer functions *********************

    
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
         prefix_html = if work_session_boolean then "Arbeitsphase: " else "Pause: "
         m = m+1 # because no seconds are displayed, 40sec should be 1minute
         html = prefix_html + "Noch " + m + " Min"
      	 # "+leadingzero(h) + ':' +
           # + ':' + leadingzero(s)
         $("#timer_box").html(html)
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
      # downloaded from http://www.freesound.org/people/Benboncan/sounds/66951/	
      $.fn.soundPlay(
        url: '/audios/boxing-bell.wav',
        playerId: 'embed_player',
        command: 'play')


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
      date = new Date()
      minutes = date.getMinutes()
      seconds = date.getSeconds()
      # if time is below 50 minutes, then we are in the 50 minutes work session, else in the 10 min pause   
      work_session_duration=50
      session_duration = if minutes<work_session_duration then work_session_duration*60 else (60 - work_session_duration) *60         
      time_to_full_hour =  60*60 - minutes*60 - seconds
      countdown = if minutes<work_session_duration then time_to_full_hour - (60-work_session_duration)*60 else time_to_full_hour
      timer_is_on=1
      doCount(countdown,minutes<work_session_duration )  
    
    if $("#timer_box").length>0   
      startTimer()
    
    
    
    
    session.addEventListener 'sessionConnected', sessionConnectedHandler
    session.addEventListener 'streamCreated', streamCreatedHandler
    session.addEventListener 'signalReceived', signalReceivedHandler
    session.addEventListener 'connectionCreated', connectionCreatedHandler
    session.addEventListener 'connectionDestroyed', connectionDestroyedHandler
    TB.addEventListener 'exception', exceptionHandler
    session.connect api_key, tok_token
    bind_penalty_forms()




