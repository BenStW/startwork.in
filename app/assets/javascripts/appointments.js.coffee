

$(document).ready ->
   if $(".init_popover").length>0
     $(".init_popover").popover()


   write_data_into_modal = (element)->
      appointment_id = element.data("appointment_id")
      token = element.data("token")
      sender = element.data("sender")
      if appointment_id?
         $("#appointment").data("appointment_id",appointment_id)
         $("#appointment_id").html(appointment_id)
      else
         $("#appointment").data("appointment_id","")
         $("#appointment_id").html("")
      if token?         
         $("#appointment").data("token",token)
         $("#token").html(token)
      else
         $("#appointment").data("token","")
         $("#token").html("")
      if sender?         
         $("#appointment_sender").html("von "+sender)
      else
         $("#appointment_sender").html("")

   read_times = (element)->
      start_time = element.data("start_time")
      timezone_offset = 60000*new Date().getTimezoneOffset()
      start_time = new Date(getDateFromFormat(start_time, "yyyy-mm-dd HH:mm:ss UTC") - timezone_offset)
      end_time = element.data("end_time")
      end_time =  new Date(getDateFromFormat(end_time, "yyyy-mm-dd HH:mm:ss UTC") - timezone_offset)
      [start_time, end_time]

   edit_work_session = (element)->
      fill_main_modal(element)
      show_filled_main_modal("edit")

   accept_work_session = (element)->
      fill_main_modal(element)
      show_filled_main_modal("accept")

   join_work_session = (element)->
      fill_main_modal(element)
      show_filled_main_modal("join")
    
       
   leading_zero = (hour) ->
      if hour < 10
          "0"+hour
      else
         hour
   
   from_day_and_hours_to_dates = (day,start_hour,end_hour)->
      day = $.datepicker.parseDate('yy-mm-dd',day)	
      start_time = new Date(day)   
      end_time = new Date(day)   
      start_time.setHours(start_hour)    
      end_time.setHours(end_hour) 
      [start_time,end_time]

   to_appointment_string = (day, start_hour, end_hour)->
      day_str = $.datepicker.formatDate('DD, dd.mm.yy', day, {dayNames: $.datepicker.regional['de'].dayNames})
      str = "Am "+day_str+" von "+start_hour+":00 bis "+end_hour+":00"
   
   get_appointment_token = (start_time=null, end_time=null, callback) ->
     data = []
     if start_time? and end_time?
        data = 
           start_time:start_time.toString()
           end_time:end_time.toString()
     $.ajax
      url: $("#urls").data("get_token_appointment_url")
      data: data
      type: "POST"
      statusCode:
        200: (data)->
           console.log data.responseText
           if callback?
             callback(data.responseText)



   fb_popup_with_appointment = (callback)->
      name =  "Einladung zum gemeinsamen Arbeiten: " + $("#appointment_str").html()     
      message = "message"
      token = $("#appointment").data("token")
      appointment_id = $("#appointment").data("appointment_id")
      link = $("#urls").data("appointments_url")+"/"+appointment_id+"/?token="+token
      console.log link
      fb_popup(name, message, link)




   fb_popup = (name, message, link) ->	
      FB.ui(
         {method: 'send',
         name: name,
         message: message,
         link: "http://startwork.in"},
         (response) ->
            $('#main_page_modal').modal('hide')
            if $("#welcome_box").length>0
                window.location = $("#urls").data("root_url")
            console.log "facebook popup response:"
            if response?
              console.log "The User has sent the appointment to FB friends"
              txt = "Die Einladung wurde erfolgreich versendet."
              notice_html = "<div  class='alert alert-success'>"+txt+"</div>"
              $("#notice").html(notice_html)
            else
              console.log "The User has cancelled the FB popup window")
          
   reload_my_work_sessions = ->
     if  $("#my_appointments").length>0
       $.ajax
         url: $("#urls").data("my_appointments_url")
         statusCode:
           200: (my_work_sessions_data) ->
             $("#my_appointments").html(my_work_sessions_data)
             $(".init_popover").popover()
             $(".edit_appointment").bind('click', ->
                 $('#main_page_modal').modal("show")
                 edit_work_session($(this)))

   accept_appointment = (token, callback)->
     $.ajax
       url: $("#urls").data("accept_appointment_url")+".json?token="+token
       type: 'POST',
       async: false, # the call must be synchronous so it is still part of the  user event and the popup won't be blocked
       statusCode:
         422: (response)->
           txt = "Die Verabredung konnte nicht gespeichert werden.."
           notice_html = "<div  class='alert alert-error'>"+txt+"</div>"
           $("#notice").html(notice_html)	
         200: (response)->
           txt = "Die Einladung wurde angenommen. Achte bitte darauf, dich pünktlich zur WorkSession anzumelden."
           notice_html = "<div  class='alert alert-success'>"+txt+"</div>"
           $("#notice").html(notice_html)
           reload_my_work_sessions()
           show_filled_main_modal("invite_after_create")
           fb_popup_with_appointment()
           if callback?
              callback()

   save_appointment = (appointment_id, start_time, end_time, callback)->
     data = 
        appointment:
          start_time: start_time.toString()
          end_time: end_time.toString()
          id: appointment_id
     $.ajax
       url: $("#urls").data("appointments_url")+"/"+appointment_id,
       data: data,
       type: 'PUT',
       async: false, # the call must be synchronous so it is still part of the  user event and the popup won't be blocked
       statusCode:
         404: (response)->
           txt = "Die Verabredung konnte nicht gespeichert werden.."
           notice_html = "<div  class='alert alert-error'>"+txt+"</div>"
           $("#notice").html(notice_html)	
         200: (response)->
           txt = "Die Verabredung wurde gespeichert. Achte bitte darauf, dich pünktlich zur WorkSession anzumelden."
           notice_html = "<div  class='alert alert-success'>"+txt+"</div>"
           $("#notice").html(notice_html)
           reload_my_work_sessions()
           show_filled_main_modal("invite_after_create")
           fb_popup_with_appointment()
           if callback?
              callback()
   
   create_appointment = (start_time, end_time, callback)->
     data = 
       appointment:
         start_time: start_time.toString()
         end_time: end_time.toString()
     $.ajax
       url: $("#urls").data("appointments_url"),
       data: data,
       type: 'POST',
       async: false, # the call must be synchronous so it is still part of the  user event and the popup won't be blocked
       statusCode:
         404: (response)->
           txt = "Die Verabredung konnte nicht gespeichert werden.."
           notice_html = "<div  class='alert alert-error'>"+txt+"</div>"
           $("#notice").html(notice_html)	
         200: (response)->
           txt = "Die Verabredung wurde erstellt. Achte bitte darauf, dich pünktlich zur WorkSession anzumelden."
           notice_html = "<div  class='alert alert-success'>"+txt+"</div>"
           $("#notice").html(notice_html)
           $("#appointment").data("token",response.token)
           $("#token").html(response.token)
           $("#appointment").data("appointment_id",response.id)
           $("#appointment_id").html(response.id)

           reload_my_work_sessions()
           show_filled_main_modal("invite_after_create")
           fb_popup_with_appointment()
           if callback?
              callback()


   show_filled_main_modal = (action)->
      if action == "edit"
         $("#main_modal_title").html("Verabredung aktualisieren")
         $("#main_modal_dates").css("display","inline")
         $("#main_modal_delete").css("display","inline")
         $("#main_modal_accept").css("display","none")
         $("#main_modal_save").css("display","inline")
         $("#appointment_sender").css("display","none")
         $("#main_modal_close").css("display","none")
         $("#fb_space").css("display","none")
         $("#main_modal_join").css("display","none")
      else if action == "accept"
         $("#main_modal_title").html("Einladung annehmen")
         $("#main_modal_dates").css("display","none")
         $("#main_modal_delete").css("display","none")
         $("#main_modal_accept").css("display","inline")
         $("#main_modal_save").css("display","none")
         $("#appointment_sender").css("display","inline")
         $("#main_modal_close").css("display","none")
         $("#fb_space").css("display","none")
         $("#main_modal_join").css("display","none")
      else if action == "create"
         $("#main_modal_title").html("Termin für Verabredung festlegen")
         $("#main_modal_dates").css("display","inline")
         $("#main_modal_delete").css("display","none")
         $("#main_modal_accept").css("display","none")
         $("#main_modal_save").css("display","inline")
         $("#appointment_sender").css("display","none")
         $("#main_modal_close").css("display","none")
         $("#fb_space").css("display","none")
         $("#main_modal_join").css("display","none")
      else if action == "invite_after_create"
         $("#main_modal_title").html("Mit Freunden verabreden")
         $("#main_modal_dates").css("display","none")
         $("#main_modal_delete").css("display","none")
         $("#main_modal_accept").css("display","none")
         $("#main_modal_save").css("display","none")
         $("#appointment_sender").css("display","none")
         $("#main_modal_close").css("display","inline")
         $("#fb_space").css("display","block")
         $("#main_modal_join").css("display","none")
      else if action == "join"
         $("#main_modal_title").html("Bei Arbeitssitzung teilnehmen")
         $("#main_modal_dates").css("display","none")
         $("#main_modal_delete").css("display","none")
         $("#main_modal_accept").css("display","none")
         $("#main_modal_save").css("display","none")
         $("#appointment_sender").css("display","none")
         $("#main_modal_close").css("display","none")
         $("#fb_space").css("display","none")
         $("#main_modal_join").css("display","inline")

      show_appointment_string()

   show_appointment_string = ->
      day = $.datepicker.parseDate('yy-mm-dd', $(".main_modal_day.btn-primary").data("day"))
      appointment_str = to_appointment_string(
        day, 
        $("#date_main_modal_start").val(),
        $("#date_main_modal_end").val())
      $("#appointment_str").html(appointment_str)

   show_invite_buttons = ->
      $("#main_modal_invite").css("display","inline")


   fill_main_modal = (element)->
      [start_time,end_time] = read_times(element)
      fill_main_modal_with_dates(start_time,end_time)
      write_data_into_modal(element)

   fill_main_modal_with_dates = (start_time,end_time) ->
      day = new Date(start_time)
      day.setHours(0,0,0,0)
      day_str =  $.datepicker.formatDate('yy-mm-dd', day)
      $(".main_modal_day").removeClass("btn-primary")
      $(".main_modal_day[data-day='"+day_str+"']").addClass("btn-primary")
      $('#date_main_modal_start option').removeAttr('selected')
      $("#date_main_modal_start option[value='"+leading_zero(start_time.getHours())+"']").attr('selected',true)
      $('#date_main_modal_end option').removeAttr('selected')
      $("#date_main_modal_end option[value='"+leading_zero(end_time.getHours())+"']").attr('selected',true)

   $("#date_main_modal_start").change ->
      show_appointment_string()
   $("#date_main_modal_end").change ->
      show_appointment_string()

   
   $(".main_modal_day").click (event) ->
      $(".main_modal_day").removeClass("btn-primary")
      $("#"+event.target.id).addClass("btn-primary")
      show_appointment_string()

   $("#main_modal_invite").click (event) ->
     fb_popup_with_appointment()
	

   $("#main_modal_delete").click (event) ->
      appointment_id = $("#appointment").data("appointment_id")
      $.ajax
        url: $("#urls").data("appointments_url")+"/"+appointment_id,
        type: 'DELETE',
        statusCode:
          200: (x)->
            console.log x.responseText
            txt = "Der Termin wurde gelöscht."
            notice_html = "<div  class='alert alert-success'>"+txt+"</div>"
            $("#notice").html(notice_html)
            reload_my_work_sessions()
   
   $("#main_modal_save").click ->
      appointment_id = $("#appointment").data("appointment_id")
   
      [start_time, end_time] = from_day_and_hours_to_dates(
         $(".main_modal_day.btn-primary").data("day"), 
         $("#date_main_modal_start").val(),
         $("#date_main_modal_end").val())
      console.log "start_time = "+start_time
      console.log "end_time = "+end_time
      if appointment_id
         save_appointment(appointment_id, start_time, end_time, (response)->
            console.log response)
      else
         create_appointment(start_time, end_time, (response)->
            console.log response)

   $("#main_modal_accept").click ->
       token = $("#appointment").data("token")
       accept_appointment(token, (response) ->
            console.log response)

   $("#main_modal_join").click ->
       token = $("#appointment").data("token")
       accept_appointment(token ,(response) ->
          console.log response)

   $("#launch_modal_button").click (event)->
      $('#main_page_modal').modal("show")
      write_data_into_modal($(this))
      show_filled_main_modal("create")
   
   
   $(".accept_appointment").click (event) ->
      $('#main_page_modal').modal("show")
      accept_work_session($(this))
   
   $(".edit_appointment").click ->
     $('#main_page_modal').modal("show")     
     edit_work_session($(this))
   
   $(".send_dialogue_button").click ->
      name = "StartWork.in - Gemeinsam produktiver. Mit Leuten wie dir."
      message = "message"
      link = "http://startwork.in"
      fb_popup(name, message, link)
   
   $(".join_appointment").click ->
      $('#main_page_modal').modal("show")     
      join_work_session($(this))
   


   # WELCOME page
   if $("#welcome_box").length>0 and $("#show_and_welcome_carousel").length==0
    $("#notice").remove()
    show_appointment_string()
   # END OF WELCOME page

   $(".fill_initial_dates").click ->
      fill_initial_dates()
	
   fill_initial_dates = ->	
      start_time = new Date($("#appointment").data("start_time"))
      end_time = new Date($("#appointment").data("end_time"))
      day = new Date(start_time)  
      start_hour = start_time.getHours()
      end_hour = end_time.getHours()      
      appointment_str = to_appointment_string(day, start_hour, end_hour)
      $("#appointment_str").html(appointment_str)

    $("#show_and_welcome_save_continue").click ->
       fb_popup_with_appointment()


    if $("#show_and_welcome_carousel").length>0 or $("#appointment_carousel").length>0
      fill_initial_dates()
   

     
      
 