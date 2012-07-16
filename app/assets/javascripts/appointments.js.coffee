

$(document).ready ->


	
   if $('.column_same_height').length>0
      heights= $(".column_same_height").map(->
            return $(this).outerHeight(true)).get()
      Array.max = (array) ->
        return Math.max.apply(Math, array)
      max = Array.max(heights)
      $('.column_same_height').height(max)

      launch_main_modal = ->
        $('#main_page_modal').modal("show")
        $('.modal-backdrop').height(0)
        $('#main_page_modal').height(max)
        $('.modal-arrow').css("top",(max - 75) / 2)


   $("#launch_modal_button").click (event)->
      launch_main_modal()
      write_data_into_modal($(this))
      show_filled_main_modal("create")

   
   $(".accept_appointment").click (event) ->
      launch_main_modal()
      accept_work_session($(this))
   
   $(".edit_appointment").click ->
     launch_main_modal()     
     edit_work_session($(this))

   $(".send_dialogue_button").click ->
      name = "StartWork.in - Gemeinsam produktiver. Mit Leuten wie dir."
      message = "message"
      link = "http://startwork.in"
      fb_popup(name, message, link)
      

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
           callback(data.responseText)



   fb_popup_with_appointment = (callback)->
      name =  "Einladung zum gemeinsamen Lernen: " + $("#appointment_str").html()     
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
              $("#notice").html(notice_html)
            else
              console.log "The User has cancelled the FB popup window"
            if callback
              callback(response))
          
   reload_my_work_sessions = ->
     if  $("#my_appointments").length>0
       $.ajax
         url: $("#urls").data("my_appointments_url")
         statusCode:
           200: (my_work_sessions_data) ->
             $("#my_appointments").html(my_work_sessions_data)
             $(".edit_appointment").bind('click', ->
                 launch_main_modal()
                 edit_work_session($(this)))

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
         422: (response)->
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
         422: (response)->
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
         
   accept_appointment = (token)->
     $.ajax
       url: $("#urls").data("accept_appointment_url")+"?token="+token
       statusCode:
         200: (response)->
           console.log response
           txt = "Die Einladung wurde angenommen. Achte bitte darauf, dich pünktlich zur WorkSession anzumelden."
           notice_html = "<div  class='alert alert-success'>"+txt+"</div>"
           $("#notice").html(notice_html)
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
       #  $("#main_modal_invite").css("display","none")
      else if action == "accept"
         $("#main_modal_title").html("Einladung annehmen")
         $("#main_modal_dates").css("display","none")
         $("#main_modal_delete").css("display","none")
         $("#main_modal_accept").css("display","inline")
         $("#main_modal_save").css("display","none")
         $("#appointment_sender").css("display","inline")
         $("#main_modal_close").css("display","none")
         $("#fb_space").css("display","none")
       #  $("#main_modal_invite").css("display","none")
      else if action == "create"
         $("#main_modal_title").html("Termin für Verabredung festlegen")
         $("#main_modal_dates").css("display","inline")
         $("#main_modal_delete").css("display","none")
         $("#main_modal_accept").css("display","none")
         $("#main_modal_save").css("display","inline")
         $("#appointment_sender").css("display","none")
         $("#main_modal_close").css("display","none")
         $("#fb_space").css("display","none")
       #  $("#main_modal_invite").css("display","none")
      else if action == "invite_after_create"
         $("#main_modal_title").html("Mit Freunden verabreden")
         $("#main_modal_dates").css("display","none")
         $("#main_modal_delete").css("display","none")
         $("#main_modal_accept").css("display","none")
         $("#main_modal_save").css("display","none")
         $("#appointment_sender").css("display","none")
         $("#main_modal_close").css("display","inline")
         $("#fb_space").css("display","block")
       #  $("#main_modal_invite").css("display","inline")

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



   # WELCOME page
   if $("#welcome_box").length>0 and $("#show_and_welcome_carousel").length==0
    $("#notice").remove()
    show_appointment_string()
   # END OF WELCOME page


   if("#show_and_welcome_carousel").length>0
      start_time = new Date($("#appointment").data("start_time"))
      end_time = new Date($("#appointment").data("end_time"))
      day = new Date(start_time)  
      start_hour = start_time.getHours()
      end_hour = end_time.getHours()      
      appointment_str = to_appointment_string(day, start_hour, end_hour)
      $("#appointment_str").html(appointment_str)

    $("#show_and_welcome_save_continue").click ->
       fb_popup_with_appointment()
   
   
   # ------------- functions for calendar overview------ --------- #
   
     
      
   
   
   if $("#calendar").length>0
   
      backendEventToFrontendEvent = (backend_event) ->
        start_time = new Date(backend_event.start_time)
        end_time = new Date(backend_event.start_time)
        end_time.setHours(start_time.getHours()+1)
        if backend_event.current_user
            column_id = 0
        else if backend_event.friend
            column_id = 1
        else
            column_id = 2
        jquery_calendar_event = 
          id: backend_event.id
          start: start_time
          end: end_time
          userId: column_id
          name: "<tr><td>"+backend_event.first_name + " " + backend_event.last_name+"</td><td><img src='http://graph.facebook.com/"+backend_event.fb_ui+"/picture'></td></tr>"
   
      merge_events_of_same_time_and_column = (events) ->
         if events.length < 2
            return events
         events = events.sort(
             (a,b) ->  a.start-b.start)
         return_events = []
         first_event = events.shift()
         for event in events
            if Date.parse(event.start) == Date.parse(first_event.start)
              event.name = first_event.name+"<br>"+event.name
            else
              return_events.push(first_event)
            first_event = event
         return_events.push(first_event)
         return_events	
   
   
      merge_events_of_same_time = (events) ->
        own_column = []
        friend_column = []
        other_column = []
   
        for event in events
           if event.userId==0
             own_column.push event
           else if event.userId==1
             friend_column.push event
           else
             other_column.push event
        friend_column = merge_events_of_same_time_and_column(friend_column)
        other_column = merge_events_of_same_time_and_column(other_column)
        events = own_column.concat(friend_column,other_column)
        events
   
      backendEventsToFrontendEvents = (backend_events) ->
        frontend_events = (backendEventToFrontendEvent(backend_event) for backend_event in backend_events)
        frontend_events = merge_events_of_same_time(frontend_events)
        calendar_events = 
          options: 
            "showAsSeparateUser":true
            "users": ["Ich","Freunde","Andere"]	
          events: frontend_events
   	
   
      $('#calendar').weekCalendar(
        date: new Date(),
        timeslotsPerHour: 1,
        firstDayOfWeek:  new Date().getDay(), 
        defaultEventLength: 1,
        height:  (calendar) ->
          h = $(window).height() #- $("h1").outerHeight(true)
          #console.log "height="+h
          h
        shortDays: $.datepicker.regional['de'].dayNamesShort, 
        longDays: $.datepicker.regional['de'].dayNames, 
        shortMonths: $.datepicker.regional['de'].monthNamesShort, 
        longMonths: $.datepicker.regional['de'].monthNames
        # start and end contain the start and end time of the week calendar, but they are not needed in this application
        # callback contains the callback function, which argument should contain the calendar events
        data: (start, end, callback) ->
          # under the following url the backend calendar events are fetched.
          url = $("#data").data("base_url")+'.json' 
          $.getJSON(url 
              # the anonymous function to be called after the JSON-request
              (frontend_events) -> 
                frontend_events=backendEventsToFrontendEvents(frontend_events)            
                callback(frontend_events)
              )
        
        newEventText: "",
        buttons: false,
        timeFormat: "H",
        timeSeparator: " - ",
        allowCalEventOverlap: false,
        calendarBeforeLoad: ->
         #$(".wc-user-header").css("height","50px")
         # $(".wc-user-1").css({backgroundColor: "#999", border:"1px solid #888"});
         # $(".wc-user-1").css("background-color","grey")
         # $(".wc-user-2").css("background-color","grey")
         # $(".wc-user-3").css("background-color","grey")
        
        draggable: ->
          false
        resizable: ->
          false
        eventNew : (calEvent, event, FreeBusyManager, calendar)-> 
           $(calendar).weekCalendar('removeEvent',calEvent.id)

        eventMouseover: (event,element,domEvent) ->
          #  if event.userId>0
             $(domEvent.target).attr("rel","popover")
             title = "<center>"+event.start.getHours()+":00 </center><br><table class='table'>"+event.name+"</table>"
             $(domEvent.target).attr("data-title",title)
             $(domEvent.target).popover("show"))
     
      