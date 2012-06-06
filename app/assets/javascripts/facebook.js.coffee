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

   popup_work_session_new = (url)->
     width = 200 
     height = 200	   
     padding = 20	
     screenX = screen.availWidth
     screenY = screen.availHeight
     height = screenY
     if (screenX <= width + 2*padding)
        screenX = width + 2*padding;
     doc_width=$(document).width()
     window_width = width + 2*padding
     popup_start = screenX - width + 2*padding
     #popup_start = doc_width - width
     window.open(url,
        'StartWork',
        'width='+window_width+',height='+height+',location=no,menubar=no,toolbar=no,scrollbars=yes,resizable=yes,left='+popup_start+',top=0')

   adjust_window =  ->
     screenX=screen.availWidth
     screenY=screen.availHeight
     if (screenX<225)
       screenX=224
     window.moveTo(screenX-224,0)
     window.resizeTo(224, screenY)

   $("#pop_up_window").click ->
      popup_work_session_new("http://localhost:3000/facebook")

   if $("#fb-root1").length > 0
     FB.init(
             appId  : '330646523672055',#production '232041530243765',#local
             frictionlessRequests: true,
           )
     $("#send_requests1").click ->    
       FB.ui(
          {method: 'apprequests',
          message: 'Einladung zum gemeinsamen Lernen und Arbeiten auf StartWork'
            }, requestCallback)
             
     requestCallback = (response) -> 
      # alert "thanks for your request"
