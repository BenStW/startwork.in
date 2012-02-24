# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# document needs to be loaded, as parameters are passed from DOM to JS
$(document).ready ->
  width=100
  heigth=100
  padding=5  

  $('.connect').click (event)-> 
    url = event.target
    doc_width=$(document).width()
    padding = 20
    window_width=2*width+padding
    window_heigth=5 * heigth+10*padding
    popup_start=doc_width-width
    window.open(url,
      'StartWork',
      'width='+window_width+',height1='+window_heigth+',location=no,menubar=no,toolbar=no,scrollbars=yes,resizable=yes,left='+popup_start)
    false
  
  # only run code when videobox is present
  if $('#video_window').length > 0    
    
    # creates for each new connection a user_box with a text_box and a stream_box
    subscribeToStreams = (streams) ->       
      for stream in streams
        if stream.connection.connectionId == session.connection.connectionId 
        else
          connectionData = JSON.parse(stream.connection.data)          
          user_name = connectionData.user_name
          user_id = connectionData.user_id
          replaceElementId = "stream_box_tmp_"+user_id
          html = 
            "<div class=user_box id=user_box_"+user_id+" data-user_id="+user_id+">
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
             to_user_name = data.to_user_name
             from_user_name = data.from_user_name
             to_user_id = data.to_user_id
             from_user_id = data.from_user_id
             msg = "P by "+ from_user_name+"<br>"
             $("#user_box_"+to_user_id+" .text_box").append(msg)
  
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
      console.log "connection created. Post to /connection/start: data = "+data
      $.ajax
         url: '/connections/start',
         data: data,
         type: 'POST',
         success: (data) ->
             console.log data  
    
    postConnectionEnd = (user_ids) ->           
      data = 
        user_ids: user_ids
      console.log "connection ended. Post to /connection/end: data = "+data
      $.ajax
         url: '/connections/end',
         data: data,
         type: 'POST',
         success: (data) ->
             console.log data
     
    bind_penalty_forms = ->
      $(".stream_box").click (event)-> 
        my_user_id = $(".video_window").data("user_id")	
        penalty_user_id = $(this).parent(".user_box").data("user_id")
        if my_user_id != penalty_user_id
          postPenalty my_user_id, penalty_user_id				

    # The Session object dispatches SessionConnectEvent object when a session has successfully connected
    # in response to a call to the connect() method of the Session object. 
    sessionConnectedHandler = (event) ->
        replaceElementId = 'publisher_box_tmp'
        publisher = session.publish replaceElementId, windowProps
        
        # count the number of connections in hidden field
        $("#connectionCountField").val(event.connections.length)
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

      connectionsCount = parseInt($("#connectionCountField").val()) - connectionsDestroyed.length
      $("#connectionCountField").val(connectionsCount)

      user_ids = (JSON.parse(connection.data).user_id for connection in connectionsDestroyed)  

      # remove the user boxes of the lost connections 
      $("#user_box_"+user_id).remove() for user_id in user_ids 

      # if user is left alone, also end his connection
      if connectionsCount == 1
         my_user_id =  $(".video_window").data("user_id")
         user_ids.push(my_user_id)
      postConnectionEnd(user_ids)    

 
    connectionCreatedHandler = (event) ->
      connectionsCreated = event.connections 

      origConnectionsCount = parseInt($("#connectionCountField").val())
      connectionsCount = origConnectionsCount + connectionsCreated.length
      $("#connectionCountField").val(connectionsCount)	
	 
      user_ids = JSON.parse(connection.data).user_id for connection in connectionsCreated 

      # Add the own user_id , because the server tracks only video learning with 2 or more people
      # When the 2nd person connects, all browsers will send the new connections including the own user_id  
      my_user_id = $(".video_window").data("user_id")
      user_ids.push(my_user_id)
      postConnectionStart(user_ids)


    # When a stream_box was clicked, trigger a penalty
    $(".stream_box").click (event)-> 
      my_user_id = $(".video_window").data("user_id")	
      penalty_user_id = $(this).parent(".user_box").data("user_id")
      #if my_user_id != penalty_user_id
      postPenalty my_user_id, penalty_user_id


    TB.setLogLevel(TB.DEBUG) 
    session_id  = $("#video_window").data("session_id")
    tok_token = $("#video_window").data("tok_token")
    api_key = $("#video_window").data("api_key")
    session = TB.initSession session_id   

    windowProps = 
      width: width
      height: heigth

    session.addEventListener 'sessionConnected', sessionConnectedHandler
    session.addEventListener 'streamCreated', streamCreatedHandler
    session.addEventListener 'signalReceived', signalReceivedHandler
    session.addEventListener 'connectionCreated', connectionCreatedHandler
    session.addEventListener 'connectionDestroyed', connectionDestroyedHandler
    TB.addEventListener 'exception', exceptionHandler
    session.connect api_key, tok_token
    bind_penalty_forms()

    # ----------- The End --------------


    # Gets the latest chat entry from the database given somebodys connectionId
    getChatEntry = (connection_id) -> 
       $.ajax
          url: '/chat_entries/latest/' + connection_id,
          success: (data) ->
            $("#chat").append data.body + "<br>" 

    postChatEntry = (body) ->
       data = 
         connection_id: session.connection.connectionId,
         body: body
       $.ajax
         url: '/chat_entries/add',
         data: data,
         type: 'POST',
         success: (data) ->
            # Signal to other clients that we have inserted new data
            session.signal()
 
    $("#chat_input").submit ->
         # postChatEntry  $('#chat_input_text')
        postChatEntry  $("input:first").val() 	
        false


 




