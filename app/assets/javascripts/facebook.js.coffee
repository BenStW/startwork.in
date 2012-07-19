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
