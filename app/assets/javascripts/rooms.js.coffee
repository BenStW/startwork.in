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
    
    sessionConnectedHandler = (event) ->
       publisher = session.publish 'videobox'
       subscribeToStreams event.stream  
    
    streamCreatedHandler = (event) -> 
       subscribeToStreams event.streams
    
    subscribeToStreams = (streams) ->
      for stream in streams
        if stream.connection.connectionId == session.connection.connectionId 
        else
          div = document.createElement('div')
          div.setAttribute('id', 'stream' + stream.streamId)
          document.videobox.appendChild div
          session.subscribe stream, div.id
    
    session.addEventListener 'sessionConnected', sessionConnectedHandler
    session.addEventListener 'streamCreated', streamCreatedHandler
    session.connect api_key, tok_token

	


	

  

  




