# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/




# document needs to be loaded, as parameters are passed from DOM to JS
$(document).ready -> 

   if $("#test_video_window").length > 0

      width = 200 
      height = 200	   
      padding = 20
          
      my_user_id = $('#test_video_window').data("user_id")
      TB.setLogLevel(TB.DEBUG) 
      session_id  = $("#test_video_window").data("session_id")
      tok_token = $("#test_video_window").data("tok_token")
      api_key = $("#test_video_window").data("api_key")
      session = TB.initSession session_id  
      publisher = null
      audio_on = 1

      windowProps = 
        width: width
        height: height

      
      $("#voice_button").click ->
        if audio_on
           $("#voice_button").removeClass("btn-danger")
           $("#voice_button").html("Sound off")
           publisher.publishAudio(false)
           audio_on=0
        else
           $("#voice_button").addClass("btn-danger")
           $("#voice_button").html("Sound on")
           publisher.publishAudio(true)
           audio_on=1
      

      addVideoBox = (user_id, user_name) ->
          html =  "<div id='user_box_"+user_id+"' data-user_id='"+user_id+"'>                      
                      <div class='text_box'>
                        "+user_name+"<br>
                      </div><!-- text_box -->
                      <div  id='streambox_"+user_id+"' class='stream_box'>
                        <div id='stream_box_tmp_"+user_id+"' class='stream_box_tmp'>
                          <img src='/assets/video_dummy.gif'>
                        </div><!-- stream_box -->
                     </div><!-- stream_box -->		
                  </div> <!-- user_box -->"
          $("#test_video_window").append(html)
      
      subscribeToStreams = (streams) -> 
        console.log("subscribe to "+streams.length+" streams")
        for stream in streams
          if stream.connection.connectionId == session.connection.connectionId 
            # console.log("   same connection. Set the visibility of the publisher to hidden.")
          else
            connectionData = JSON.parse(stream.connection.data)  
            console.log "**** Connection Data *****"
            console.log connectionData        
            user_id = connectionData.user_id
            user_name = connectionData.user_name
            console.log("**** add video box for user_id "+user_id+" and name="+user_name)
            addVideoBox(user_id, user_name)
            replaceElementId = "stream_box_tmp_"+user_id
            console.log("replaceElementId = "+replaceElementId)
            session.subscribe stream, replaceElementId, windowProps
            console.log("***** replaced  = "+replaceElementId)
              

      
      
      
      # The Session object dispatches SessionConnectEvent object when a session has successfully connected
      # in response to a call to the connect() method of the Session object. 
      sessionConnectedHandler = (event) ->
        replaceElementId = "publisher_box_tmp"
      
        properties = 
          publishAudio: true
          width: width
          height: height
        publisher = session.publish replaceElementId, properties

        user_ids = (JSON.parse(connection.data).user_id for connection in event.connections)
        subscribeToStreams event.streams 
             
      
      
      #The Session object dispatches StreamEvent events when a session has a stream created or destroyed.
      streamCreatedHandler = (event) -> 
         # Subscribe to any new streams that are created
         subscribeToStreams event.streams
      

      
      
      connectionDestroyedHandler = (event) ->
        connectionsDestroyed = event.connections  
        user_ids = (JSON.parse(connection.data).user_id for connection in connectionsDestroyed)  
        for user_id in user_ids
           $("#user_box_"+user_id).remove()
	
      
      connectionCreatedHandler = (event) ->
         console.log "connection created"
      
      
      session.addEventListener 'sessionConnected', sessionConnectedHandler #publishes own video
      session.addEventListener 'streamCreated', streamCreatedHandler # shows videos of the others, creates video box
      session.addEventListener 'connectionCreated', connectionCreatedHandler
      session.addEventListener 'connectionDestroyed', connectionDestroyedHandler
      session.connect api_key, tok_token
      
    
    
    
    