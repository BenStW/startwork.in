# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# document needs to be loaded, as parameters are passed from DOM to JS
$(document).ready ->
  
  # only run code when videobox is present
  if $('#camera_settings').length > 0 
    TB.setLogLevel(TB.DEBUG) 
    session_id  = $("#camera").data("session_id")
    tok_token = $("#camera").data("tok_token")
    api_key = $("#camera").data("api_key")
    session = TB.initSession session_id   

    windowProps = 
      width: 300
      height: 300
    
    # The Session object dispatches SessionConnectEvent object when a session has successfully connected
    # in response to a call to the connect() method of the Session object. 
    sessionConnectedHandler = (event) ->
       replaceElementId = 'publisher_box_tmp'
       publisher = session.publish replaceElementId, windowProps
    
    session.addEventListener 'sessionConnected', sessionConnectedHandler
    session.connect api_key, tok_token


 




