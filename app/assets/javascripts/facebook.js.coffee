$(document).ready -> 

   if $("#fb-root").length > 0
     FB.init(
             appId : $("#fb-root").data("app") 
             frictionlessRequests: true,
           )
     $("#request_dialogue").click ->    
       FB.ui(
          {method: 'apprequests',
          message: 'Einladung zum gemeinsamen Lernen und Arbeiten auf StartWork'
            }, requestCallback)
     $("#send_dialogue").click ->    
       FB.ui(
          {method: 'send',
          name: 'Einladung zum gemeinsamen Lernen und Arbeiten auf StartWork',
          message: 'Einladung zum gemeinsamen Lernen und Arbeiten auf StartWork',
          link: 'http://startwork.in',
            })
             
     requestCallback = (response) -> 
      # alert "thanks for your request"
