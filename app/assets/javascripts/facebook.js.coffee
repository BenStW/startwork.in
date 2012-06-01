$(document).ready -> 
  # if $("#fb-root1").length > 0
  #   FB.init(
  #      appId: '330646523672055',#production
  #      xfbml: true, 
  #      cookie: true)
  #   FB.ui(
  #      method: 'send',
  #      name: 'StartWork',
  #      link: 'http://localhost:3000')
   if $("#fb-root").length > 0
     FB.init(
             appId  : '330646523672055',#production '232041530243765',#local
             frictionlessRequests: true,
           )
     $("#send_requests").click ->    
       FB.ui(
          {method: 'apprequests',
          message: 'Einladung zum gemeinsamen Lernen und Arbeiten auf StartWork'
            }, requestCallback)
             
     requestCallback = (response) -> 
      # alert "thanks for your request"
