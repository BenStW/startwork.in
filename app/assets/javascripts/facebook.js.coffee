$(document).ready -> 

   if $("#fb-root").length > 0
      FB.init(
              appId : $("#fb-root").data("app") 
              frictionlessRequests: true,
            )
