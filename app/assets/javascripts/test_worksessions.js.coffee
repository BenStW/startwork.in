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
      hide_pub_by_visibility = 1
      hide_pub_by_display_none = 1
      hide_pub_by_move = 1
      

      windowProps = 
        width: width
        height: height
      

      
      $("#hide_pub_by_visibility").click ->
        if hide_pub_by_visibility
            $("#publisher_box").css("visibility", "visible")
            hide_pub_by_visibility=0
        else
            $("#publisher_box").css("visibility", "hidden")
            hide_pub_by_visibility=1

      $("#hide_pub_by_display_none").click ->
        if hide_pub_by_display_none
            $("#publisher_box").css("visibility", "visible")
            hide_pub_by_display_none=0
        else
            $("#publisher_box").css("visibility", "hidden")
            hide_pub_by_display_none=1
 
      $("#hide_pub_by_move").click ->
        if hide_pub_by_move
            $("#publisher_box").css("width", "1px")
            $("#publisher_box").css("height", "1px")
            $("#publisher_box").css("top", "-10px")
            $("#publisher_box").css("left", "-10px")
            hide_pub_by_move=0
        else
            $("#publisher_box").css("width", "100px")
            $("#publisher_box").css("height", "100px")
            $("#publisher_box").css("top", "10px")
            $("#publisher_box").css("left", "10px")
            hide_pub_by_move=1

      $("#add_box").click ->
           html =  "<div class='user_box'>
		              <div class=text_box>
		                User<br>
		              </div><!-- text_box -->
	                  <div class=stream_box>
                         <div class=stream_box_tmp>
                           <img src='/assets/video_dummy.gif'>
                         </div><!-- stream_box -->
                      </div><!-- stream_box -->		
                   </div> <!-- user_box -->"
           $("#test_video_window").append(html)
      
      $("#walkie_button").mousedown ->
        $("#walkie_button").addClass("btn-danger")
        $("#walkie_button").html("Sound on for me")
        if publisher
           console.log "mouseDown: publishAudio=true"	
           publisher.publishAudio(true)
      $("#walkie_button").mouseup ->
        $("#walkie_button").removeClass("btn-danger")
        $("#walkie_button").html("Sound off for me")
        if publisher
           console.log "mouseUp: publishAudio=false"		
           publisher.publishAudio(false)
      

      
      subscribeToStreams = (streams) -> 
        console.log("subscribe to "+streams.length+" streams")
        for stream in streams
          if stream.connection.connectionId == session.connection.connectionId 
             console.log("   same connection. Set the visibility of the publisher to hidden.")
          #   hidePublisher()
            # publishAudio =  if isWorkSession() then false else true
            # publisher.publishAudio(publishAudio)
          else
            connectionData = JSON.parse(stream.connection.data)          
            user_id = connectionData.user_id
            replaceElementId = "stream_box_tmp_"+user_id
            console.log("replaceElementId = "+replaceElementId)
            session.subscribe stream, replaceElementId, windowProps
              

       
      		
      
      
      
      # The Session object dispatches SessionConnectEvent object when a session has successfully connected
      # in response to a call to the connect() method of the Session object. 
      sessionConnectedHandler = (event) ->
        replaceElementId = "publisher_box_tmp"
      
        properties = 
          publishAudio: true
          width: width
          height: height
        publisher = session.publish replaceElementId, properties

        subscribeToStreams event.streams 
             
      
      
      #The Session object dispatches StreamEvent events when a session has a stream created or destroyed.
      streamCreatedHandler = (event) -> 
         # Subscribe to any new streams that are created
         subscribeToStreams event.streams
      
  
      
      session.addEventListener 'sessionConnected', sessionConnectedHandler #publishes own video
      session.addEventListener 'streamCreated', streamCreatedHandler # shows videos of the others
      # session.addEventListener 'signalReceived', signalReceivedHandler
   #   session.addEventListener 'connectionCreated', connectionCreatedHandler
   #   session.addEventListener 'connectionDestroyed', connectionDestroyedHandler
    #  TB.addEventListener 'exception', exceptionHandler
      session.connect api_key, tok_token
      
    
    
    
    