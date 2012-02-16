# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# document needs to be loaded, as parameters are passed from DOM to JS
$(document).ready ->
  
  # only run code when videobox is present
  if $('#videobox').length > 0 
    TB.setLogLevel(TB.DEBUG) 
    videobox = document.getElementById("videobox")
    session_id  = videobox.dataset.session_id
    tok_token = videobox.dataset.tok_token 
    api_key = videobox.dataset.api_key
    session = TB.initSession session_id   

    windowProps = 
      width: 200
      height: 200
    
    # The Session object dispatches SessionConnectEvent object when a session has successfully connected
    # in response to a call to the connect() method of the Session object. 
    sessionConnectedHandler = (event) ->
       publisher = session.publish 'publisherbox_tmp', windowProps
       # Subscribe to streams that were in the session when we connected
       subscribeToStreams event.streams 
    
    #The Session object dispatches StreamEvent events when a session has a stream created or destroyed.
    streamCreatedHandler = (event) -> 
       # Subscribe to any new streams that are created
       subscribeToStreams event.streams
    
    subscribeToStreams = (streams) ->      
      for stream in streams
        if stream.connection.connectionId == session.connection.connectionId 
        else
          div_id = 'stream' + stream.streamId
          connectionData = JSON.parse(stream.connection.data)          
          nick_name = connectionData.user_name
          $("#subscriberbox").append("<div id="+div_id+"></div><br>"+nick_name)
          session.subscribe stream, div_id
    
    signalReceivedHandler = (event) ->  
      getChatEntry(event.fromConnection.connectionId)
    
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

  
    session.addEventListener 'sessionConnected', sessionConnectedHandler
    session.addEventListener 'streamCreated', streamCreatedHandler
    session.addEventListener 'signalReceived', signalReceivedHandler
    session.connect api_key, tok_token