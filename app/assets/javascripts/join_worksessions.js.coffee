# document needs to be loaded, as parameters are passed from DOM to JS
$(document).ready -> 

  width = 200 
  height = 200	   
  padding = 20

  popup_work_session = (url)->
    doc_width=$(document).width()
    window_width = width + 2*padding
    popup_start = doc_width - width
    window.open(url,
       'StartWork',
       'width='+window_width+',location=no,menubar=no,toolbar=no,scrollbars=yes,resizable=yes,left='+popup_start)


  $('#join_work_session').click (event)-> 
    event.preventDefault()
    url_check = $(this).attr("url_check")
    url = $(this).attr("url")
    console.log("url="+url)
    $.ajax
       url: url_check,
       type: 'GET',
       success: (data) ->
         if data
           popup_work_session(url)
         else
           alert "Du kannst erst 5 Minuten vor Beginn der WorkSession beitreten."

  $('#join_guest_work_session').click (event)-> 
     url = $(this).attr("url")
     popup_work_session(url)