# document needs to be loaded, as parameters are passed from DOM to JS
$(document).ready -> 

  popup_work_session = (video_url, info_url)->
    screenX = screen.availWidth
    screenY = screen.availHeight

    window_width = screenX * 15 / 100 
    min_width = 100
    if (window_width <= min_width)
       window_width = min_width
    popup_start = screenX - window_width
    window.location = info_url
    window.open(video_url,
       'StartWork',
       'width='+window_width+',height='+screenY+',location=no,menubar=no,toolbar=no,scrollbars=yes,resizable=yes,left='+popup_start+',top=0')

  $('#join_work_session').click (event)-> 
    event.preventDefault()
    url_check = $(this).attr("url_check")
    video_url = $(this).attr("video_url")
    info_url = $(this).attr("info_url")
    $.ajax
       url: url_check,
       type: 'GET',
       success: (data) ->
         if data
           popup_work_session(video_url,info_url)
         else
           alert "Du kannst erst 5 Minuten vor Beginn der WorkSession beitreten."

  $('#join_guest_work_session').click (event)-> 
     video_url = $(this).attr("video_url")
     info_url = $(this).attr("info_url")
     popup_work_session(video_url,info_url)

  $('#join_spont_work_session').click (event)-> 
     video_url = $(this).attr("video_url")
     info_url = $(this).attr("info_url")
     popup_work_session(video_url,info_url)
