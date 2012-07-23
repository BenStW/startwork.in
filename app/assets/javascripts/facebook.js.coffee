$(document).ready ->
   if $("#fb-root").length > 0
      FB.init(
              appId : $("#fb-root").data("app") 
              frictionlessRequests: true,
            )	
	
	
   if $(".fb-reset").length>0
	
     $(".fb-reset").click ->
        x = $(this).data("fb-reset-x")
        y = $(this).data("fb-reset-y")
        fb_reset(x,y)
   
     fb_reset = (x,y) ->
        console.log "fb-reset: x="+x+" y="+y	
        screenX = window.innerWidth
        screenY = window.innerHeight
        console.log "fb-reset: screenX="+screenX+" screenY="+screenY	

        fb_width = 595
        fb_height = 347   # 288
        $("#fb-root").css("top",(y + 25 + (fb_height - screenY) / 2))
        $("#fb-root").css("left",(x + (fb_width - screenX) / 2) - window.pageXOffset)
        console.log "fb-reset: top="+ $("#fb-root").css("top")
        console.log "fb-reset: left="+ $("#fb-root").css("left")

   $('#facebook_request_button').click ->
     console.log "sendRequest"
     FB.ui({
              method: 'apprequests',
              message: 'Check out this application!',
              title: 'Send your friends an application request',
          },
       (response) -> 
        console.log response)

   renderMFS = ->
     #First get the list of friends for this user with the Graph API
     FB.api('/me/friends', (response) -> 
        container = document.getElementById('mfs')
        mfsForm = document.createElement('form')
        mfsForm.id = 'mfsForm'
        
        #Iterate through the array of friends object and create a checkbox for each one.
        #for(var i = 0; i < Math.min(response.data.length, 10); i++) {
        for reponse_element in response.data
           friendItem = document.createElement('div')
           friendItem.id = 'friend_' + reponse_element.id;
           friendItem.innerHTML = '<input type="checkbox" name="friends" value="'+
             reponse_element.id +
             '" />' + reponse_element.name
             mfsForm.appendChild(friendItem)
           container.appendChild(mfsForm)
           
           #Create a button to send the Request(s)
           sendButton = document.createElement('input')
           sendButton.type = 'button'
           sendButton.value = 'Send Request'
           sendButton.onclick = sendRequest
           mfsForm.appendChild(sendButton))  
	
   $("#mfs_button").click ->
     console.log "mfs_button clicked"
   #  renderMFS()
  
