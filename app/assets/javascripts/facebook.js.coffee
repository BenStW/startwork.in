$(document).ready -> 
   if $("#fb-root").length > 0
     FB.init(
        appId: '330646523672055',
        xfbml: true, 
        cookie: true)
     FB.ui(
        method: 'send',
        name: 'StartWork',
        link: 'http://www.startwork.in')