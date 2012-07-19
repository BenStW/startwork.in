$(document).ready ->
   if $("#start_work_button").length>0 or 
     $('#join_work_session_after_camera_test').length>0 or
     $('#join_work_session_after_info').length>0

       add_time_and_break_on_info = ->
           time = new Date()
           absolute_minutes = time.getMinutes()
           if absolute_minutes>=5 and absolute_minutes<55
             break_work = "Arbeitssitzung"
           else
             break_work = "Pause"
           if absolute_minutes<5
             m = 5-absolute_minutes
           else if absolute_minutes<55
             m = 55-absolute_minutes
           else
             m = 65 - absolute_minutes
           html =  "noch " + m + " Min"
           $("#info_time").html(html)       
           $("#info_break_or_worksession").html(break_work)

       
       popup_work_session = ->
         group_hour_url = $("#urls").data("group_hour_url")
         info_url = $("#urls").data("info_for_group_hour_url")
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
       
         window_width = ((reduced_screenY - to_speak - timer) / 3) - name - video_border
       
         popup_start = screenX - window_width
         popUp = window.open(group_hour_url,
            'StartWork',
            'width='+window_width+',height='+screenY+',location=no,menubar=no,toolbar=no,scrollbars=yes,resizable=yes,left='+popup_start+',top=0')
         if (!popUp)
             popup_not_successful()
         else
           popUp.onload = ->
            f = ->
               if (popUp.screenX is 0)
                  popup_not_successful()
               else	
                  if info_url?
                    window.location = info_url
            setTimeout(f,0)
        
       popup_not_successful = ->
            alert "Das Video-Fenster konnte nicht geöffnet werden. Für StartWork musst du Popups erlauben."

       $("#start_work_button").click -> 
            if $(this).data("dont_show_info")
               if $(this).data("camera-success")
                  console.log "popup_work_session"
                  popup_work_session()
               else
                  window.location = $("#urls").data("camera_url")
            else
                add_time_and_break_on_info()
                $('#start_work').modal("show")
      
      
       $('#join_work_session_after_camera_test').click (event)-> 
            popup_work_session()
       
       $('#join_work_session_after_info').click (event)-> 
          if $(this).data("camera-success")
             popup_work_session()
          else
             window.location = camera_url