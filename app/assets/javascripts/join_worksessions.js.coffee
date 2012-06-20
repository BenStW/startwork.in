# document needs to be loaded, as parameters are passed from DOM to JS
$(document).ready -> 
  popup_work_session = (video_url, info_url)->
    screenX = screen.availWidth

    screenY = screen.availHeight
    taskbar = 48
    browser_row = 56
    feedback = 35
    reduced_screenY = screenY - taskbar - browser_row - feedback

    timer = 48
    to_speak = 64
    name = 12
    video_border =  12

    console.log "screenY = " + screenY
    console.log "reduced_sreenY = " + reduced_screenY
   
    window_width = ((reduced_screenY - to_speak - timer) / 3) - name - video_border
    console.log "window_width = " + window_width

    popup_start = screenX - window_width
    popUp = window.open(video_url,
       'StartWork',
       'width='+window_width+',height='+screenY+',location=no,menubar=no,toolbar=no,scrollbars=yes,resizable=yes,left='+popup_start+',top=0')
    console.log popUp
    if (!popUp)
        popup_not_successful()
    else
      popUp.onload = ->
       f = ->
          if (popUp.screenX is 0)
             popup_not_successful()
          else	
             window.location = info_url
       setTimeout(f,0)

  popup_not_successful = ->
       alert "Das Video-Fenster konnte nicht geöffnet werden. Für StartWork musst du Popups erlauben."

  $('#join_work_session').click (event)-> 
  #  event.preventDefault()
    url_check = $("#urls").data("url_check_url")
    video_url = $("#urls").data("video_url")
    info_url = $("#urls").data("info_url")

    $.ajax
       url: url_check,
       type: 'GET',
       success: (data) ->
         if data
           popup_work_session(video_url,info_url)
         else
           alert "Du kannst erst 5 Minuten vor Beginn der WorkSession beitreten."

  $('#join_guest_work_session').click (event)-> 
     video_url = $("#urls").data("video_url")
     info_url = $("#urls").data("info_url")
     popup_work_session(video_url,info_url)

  $('#join_spont_work_session').click (event)-> 
     video_url = $("#urls").data("spont_video_url")
     info_url = $("#urls").data("info_url")
     popup_work_session(video_url,info_url)

