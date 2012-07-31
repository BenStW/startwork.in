

$(document).ready ->
   if $(".init_popover").length>0
     $(".init_popover").popover()


   write_data_into_modal = (element)->
      appointment_id = element.data("appointment_id")
      sender = element.data("sender")
      if appointment_id?
         $("#appointment").data("appointment_id",appointment_id)
         $("#appointment_id").html(appointment_id)
      else
         $("#appointment").data("appointment_id","")
         $("#appointment_id").html("")
      if sender?         
         $("#appointment_sender").html("von "+sender)
      else
         $("#appointment_sender").html("")


   read_times = (element)->
      start_time = element.data("start_time")
      start_time = new Date(start_time)
      end_time = element.data("end_time")
      end_time = new Date(end_time)
      [start_time, end_time]

   edit_work_session = (element)->
      fill_appointment(element)
      show_filled_appointment("edit")

   accept_work_session = (element)->
      fill_appointment(element)
      show_filled_appointment("accept")

   join_work_session = (element)->
      fill_appointment(element)
      show_filled_appointment("join")
    
       
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

   receive_appointment = (appointment_id,ids) ->
     data = 
        id: appointment_id
        user_ids: ids
     $.ajax
       url: $("#urls").data("receive_appointment_url")
       data: data
       type: "POST" 

   save_request = (appointment_id, request_str) ->
     data = 
        appointment_id: appointment_id
        request_str: request_str
     $.ajax
       url: $("#urls").data("new_request_url")
       data: data
       type: "POST"     
   
   
   send_fb_request = (appointment_id, ids,current_user_name, appointment_str,callback) ->
     message = current_user_name+" möchte gerne "+appointment_str+" auf StartWork.in mit dir lernen"
     console.log "Request message: "+message
     FB.ui({
            method: 'apprequests',
            message: message,
            title: 'Einladung zum gemeinsamen Lernen',
            to: ids 
           },(response) -> 
             console.log "request = "+response.request
             save_request(appointment_id, response.request)
             callback(response.request))
        
        
     
   
   fill_fb_request_modal = ->
      if $("#fb_request_friends").length==0	
         FB.api('/me/friends', (response) ->  
            $("#fb_request_friends_div").append($("<div />").attr("id","fb_request_friends"))
            $("#fb_request_friends").tokenInput(response.data,{
              theme: "facebook",
              minChars: 0, 
              hintText: "Name deines Freundes...",
              noResultsText: "Nichts gefunden",
              searchingText: "suchen...",
              preventDuplicates: true,
              resultsFormatter: (item)-> 
                 '<li><img src="http://graph.facebook.com/'+item.id+'/picture">' +item.name + "</li>" })
            $(".token-input-dropdown-facebook").css("z-index","9999")    
         )

 
 
   fb_popup = (name, message, link, ga_action) ->	
      FB.ui(
         {method: 'send',
         name: name,
         message: message,
         link: link},
         (response) ->
            $('#main_page_modal').modal('hide')
            if $("#welcome_box").length>0
                window.location = $("#urls").data("root_url")
            console.log "facebook popup response:"
            if response?
              console.log "The User has sent the appointment to FB friends"
              txt = "Die Einladung wurde erfolgreich versendet."
              notice_html = "<div  class='alert alert-success'>"+txt+"</div>"
              $("body").trigger("fb_event",  ga_action)
              $("#notice").html(notice_html)
            else
              console.log "The User has cancelled the FB popup window"
              $("body").trigger("fb_event",  "Cancel"+ga_action))
          
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

   accept_appointment = (appointment_id)->
     $.ajax
       url: $("#urls").data("accept_appointment_url")+".json?id="+appointment_id
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
           fill_fb_request_modal()
           show_filled_appointment("request")

   save_appointment = ->
      appointment_id = $("#appointment").data("appointment_id")

      [start_time, end_time] = from_day_and_hours_to_dates(
         $(".appointment_day.btn-primary").data("day"), 
         $("#date_appointment_start").val(),
         $("#date_appointment_end").val())
      if appointment_id
         save_appointment_with_ajax(appointment_id, start_time, end_time)
      else
         create_appointment_with_ajax(start_time, end_time)

   save_appointment_with_ajax = (appointment_id, start_time, end_time)->
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
            fill_fb_request_modal()
            show_filled_appointment("request")
   
   create_appointment_with_ajax = (start_time, end_time)->
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
           $("#appointment").data("appointment_id",response.id)
           $("#appointment_id").html(response.id)

           reload_my_work_sessions()
           fill_fb_request_modal()
           show_filled_appointment("request")



   show_filled_appointment = (action)->
      if action == "edit"
         $("#appointment_title").html("Verabredung aktualisieren")
         $("#appointment_dates").css("display","inline")
         $("#delete_appointment").css("display","inline")
         $("#accept_appointment").css("display","none")
         $("#save_appointment").css("display","inline")
         $("#appointment_sender").css("display","none")
         $("#close_appointment").css("display","none")
         $("#join_appointment").css("display","none")
         $("#request_appointment").css("display","none")
         $("#fb_request_search").css("display","none")
      else if action == "accept"
         $("#appointment_title").html("Einladung annehmen")
         $("#appointment_dates").css("display","none")
         $("#delete_appointment").css("display","none")
         $("#accept_appointment").css("display","inline")
         $("#save_appointment").css("display","none")
         $("#appointment_sender").css("display","inline")
         $("#close_appointment").css("display","none")
         $("#join_appointment").css("display","none")
         $("#request_appointment").css("display","none")
         $("#fb_request_search").css("display","none")
      else if action == "create"
         $("#appointment_title").html("Termin für Verabredung festlegen")
         $("#appointment_dates").css("display","inline")
         $("#delete_appointment").css("display","none")
         $("#accept_appointment").css("display","none")
         $("#save_appointment").css("display","inline")
         $("#appointment_sender").css("display","none")
         $("#close_appointment").css("display","none")
         $("#join_appointment").css("display","none")
         $("#request_appointment").css("display","none")
         $("#fb_request_search").css("display","none")
      else if action == "invite_after_create"
         $("#appointment_title").html("Mit Freunden verabreden")
         $("#appointment_dates").css("display","none")
         $("#delete_appointment").css("display","none")
         $("#accept_appointment").css("display","none")
         $("#save_appointment").css("display","none")
         $("#appointment_sender").css("display","none")
         $("#close_appointment").css("display","inline")
         $("#join_appointment").css("display","none")
         $("#request_appointment").css("display","none")
         $("#fb_request_search").css("display","none")
      else if action == "join"
         $("#appointment_title").html("Bei Arbeitssitzung teilnehmen")
         $("#appointment_dates").css("display","none")
         $("#delete_appointment").css("display","none")
         $("#accept_appointment").css("display","none")
         $("#save_appointment").css("display","none")
         $("#appointment_sender").css("display","none")
         $("#close_appointment").css("display","none")
         $("#join_appointment").css("display","inline")
         $("#request_appointment").css("display","none")
         $("#fb_request_search").css("display","none")
      else if action == "request"
         $("#appointment_title").html("Verabredung vereinbaren")
         $("#appointment_dates").css("display","none")
         $("#delete_appointment").css("display","none")
         $("#accept_appointment").css("display","none")
         $("#save_appointment").css("display","none")
         $("#appointment_sender").css("display","none")
         $("#close_appointment").css("display","none")
         $("#join_appointment").css("display","none")
         $("#request_appointment").css("display","inline")
         $("#fb_request_search").css("display","inline")
      show_appointment_string()

   show_appointment_string = ->
      day = $.datepicker.parseDate('yy-mm-dd', $(".appointment_day.btn-primary").data("day"))
      appointment_str = to_appointment_string(
        day, 
        $("#date_appointment_start").val(),
        $("#date_appointment_end").val())
      $("#appointment_str").html(appointment_str)

   fill_appointment = (element)->
      [start_time,end_time] = read_times(element)
      fill_appointment_with_dates(start_time,end_time)
      write_data_into_modal(element)

   fill_appointment_with_dates = (start_time,end_time) ->
      day = new Date(start_time)
      day.setHours(0,0,0,0)
      day_str =  $.datepicker.formatDate('yy-mm-dd', day)
      $(".appointment_day").removeClass("btn-primary")
      $(".appointment_day[data-day='"+day_str+"']").addClass("btn-primary")
      $('#date_appointment_start option').removeAttr('selected')
      $("#date_appointment_start option[value='"+leading_zero(start_time.getHours())+"']").attr('selected',true)
      $('#date_appointment_end option').removeAttr('selected')
      $("#date_appointment_end option[value='"+leading_zero(end_time.getHours())+"']").attr('selected',true)

   $("#date_appointment_start").change ->
      show_appointment_string()
   $("#date_appointment_end").change ->
      show_appointment_string()

   
   $(".appointment_day").click (event) ->
      $(".appointment_day").removeClass("btn-primary")
      $("#"+event.target.id).addClass("btn-primary")
      show_appointment_string()


   $("#delete_appointment").click (event) ->
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



   $("#save_appointment_on_welcomepage").click ->
      save_appointment()
      $("#skip_appointment").css("display","none")
      $("#save_appointment_on_welcomepage").css("display","none")


   $("#save_appointment").click ->
      save_appointment()


   $("#accept_appointment").click ->
       appointment_id = $("#appointment").data("appointment_id")
       accept_appointment(appointment_id, (response) ->
            console.log response)

   $("#join_appointment").click ->
       appointment_id = $("#appointment").data("appointment_id")
       accept_appointment(appointment_id ,(response) ->
          console.log response)

   $("#launch_modal_button").click (event)->
      $('#main_page_modal').modal("show")
      write_data_into_modal($(this))
      show_filled_appointment("create")
   
   
   $(".accept_appointment").click (event) ->
      $('#main_page_modal').modal("show")
      accept_work_session($(this))
   
   $(".edit_appointment").click ->
     $('#main_page_modal').modal("show")     
     edit_work_session($(this))
   
   $("#send_dialogue_after_start_work").click ->
      name = "StartWork.in - Gemeinsam produktiver. Mit Leuten wie dir."
      message = "message"
      link = "http://startwork.in"
      fb_popup(name, message, link, "Invite")

   $("#send_dialogue_button_right_block").click ->
      name = "StartWork.in - Gemeinsam produktiver. Mit Leuten wie dir."
      message = "message"
      link = "http://startwork.in"
      fb_popup(name, message, link, "Invite")
   
   $(".join_appointment").click ->
      $('#main_page_modal').modal("show")     
      join_work_session($(this))


   $("#request_appointment").click ->
     result = $("#fb_request_friends").tokenInput("get")
     console.log result
     if result.length>0
       result_ids = (item.id for item in result)
       current_user_name = $("body").data("current-user-name")
       appointment_str = $("#appointment_str").html()
       appointment_id = $("#appointment").data("appointment_id")
       receive_appointment(appointment_id,result_ids)
       send_fb_request(appointment_id,result_ids,current_user_name,appointment_str, (response) ->
          console.log "request_appointment.click: response = "+ response
          if $("body").data("action") == "welcome" or $("body").data("controller") == "appointments"
             top.location.href = $("#urls").data("root_url")
          else if $("body").data("action") == "home"
             reload_my_work_sessions())
      


   # WELCOME page
   if $("#welcome_box").length>0 and $("#show_and_welcome_carousel").length==0
      $("#notice").remove()
      show_appointment_string()
   # END OF WELCOME page


   
   fill_initial_dates = ->	
      start_time = new Date($("#appointment").data("start_time"))
      end_time = new Date($("#appointment").data("end_time"))
      day = new Date(start_time)  
      start_hour = start_time.getHours()
      end_hour = end_time.getHours()      
      appointment_str = to_appointment_string(day, start_hour, end_hour)
      $("#appointment_str").html(appointment_str)
 #
 #  $(".fill_initial_dates").click ->
 #     fill_initial_dates()
      
   if $("#appointment_carousel").length>0
     if $("body").data("controller") is "appointments" and $("body").data("action") is "show" and $("body").data("user-registered")
        $(".item").removeClass("active")
        $("#appointment_slide").addClass("active")
        $("#appointment_slide > p").html("Du hast eine Einladung erhalten!")	
     else 
        $("#appointment_carousel").carousel
          interval: false

   if $("#show_and_welcome_carousel").length>0
     $("#show_and_welcome_carousel").carousel
       interval: false

   if $("#show_and_welcome_carousel").length>0 or $("#appointment_carousel").length>0
       fill_initial_dates()

   $("#display_appointment_on_welcome_page").click ->
      show_filled_appointment("create")


