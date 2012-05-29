$(document).ready -> 
   if $("#fb-root").length > 0
     FB.init(
        appId: '232041530243765',
        xfbml: true, 
        cookie: true)
     FB.ui(
        method: 'send',
        name: 'StartWork',
        link: 'http://www.startwork.in')