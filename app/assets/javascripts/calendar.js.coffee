

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


   $("#launch_modal_button").click ->
      launch_main_modal()
      show_empty_main_modal()
      get_appointment_token(null,null, (token)->
          $("#main_page_modal").data("token",token)
          name =  "Einladung zum gemeinsamen Lernen "    
          message =  "message"          
          link = $("#urls").data("appointment_url")+"?token="+token
          fb_popup(name,message,link, (response)->
             show_filled_main_modal("new")))
   
   $(".add_work_session").click (event) ->
      launch_main_modal()
      add_work_session($(this))
   
   $(".edit_work_session").click ->
     launch_main_modal()     
     edit_work_session($(this))

   read_times = (element)->
      start_time = element.data("start_time")
      console.log "start_time = " + start_time
      timezone_offset = 60000*new Date().getTimezoneOffset()
      start_time = new Date(getDateFromFormat(start_time, "yyyy-mm-dd HH:mm:ss UTC") - timezone_offset)
      console.log "start_time = " + start_time
      end_time = element.data("end_time")
      end_time =  new Date(getDateFromFormat(end_time, "yyyy-mm-dd HH:mm:ss UTC") - timezone_offset)
      [start_time, end_time]

   edit_work_session = (element)->
      [start_time,end_time] = read_times(element)
      fill_main_modal_with_dates(start_time,end_time)
      show_filled_main_modal("edit")

   add_work_session = (element)->
      [start_time,end_time] = read_times(element)
      fill_main_modal_with_dates(start_time,end_time)
      show_filled_main_modal("add")


    
       
   leading_zero = (hour) ->
      if hour < 10
          "0"+hour
      else
         hour
   
   from_day_and_hours_to_dates = (day,start_hour,end_hour)->
      day = $.datepicker.parseDate('yy-mm-dd',day)	
      console.log "day="+day
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
      url: $("#urls").data("appointment_get_token_url")
      data: data
      type: "POST"
      statusCode:
        200: (data)->
           console.log data.responseText
           callback(data.responseText)
   
   fb_popup = (name,message,link, callback)->
      console.log link
      FB.ui(
         {method: 'send',
         name: name,
         message: message,
         link: link},
         (response) ->
          #  console.log "facebook popup response:"
          #  if response?
          #    console.log "The User has sent the appointment to FB friends"
          #  else
          #    console.log "The User has cancelled the FB popup window"
            if callback
              callback(response))

   reload_my_work_sessions = ->
     $.ajax
       url: $("#urls").data("my_work_sessions_url")
       statusCode:
         200: (my_work_sessions_data) ->
           $("#my_work_sessions").html(my_work_sessions_data)
           $(".edit_work_session").bind('click', ->
               launch_main_modal()
               edit_work_session($(this)))

   save_appointment = (token, start_time, end_time, callback)->
     data = 
        start_time: start_time.toString()
        end_time: end_time.toString()
        token: token
     $.ajax
       url: $("#urls").data("calendar_new_event_url"),
       data: data,
       type: 'POST',
       statusCode:
         200: ->
           $("#main_page_modal").removeAttr("data-token")
           txt = "Die Verabredung wurde gespeichert. Achte bitte darauf, dich pünktlich zur WorkSession anzumelden."
           notice_html = "<div  class='alert alert-success'>"+txt+"</div>"
           $("#notice").html(notice_html)
           reload_my_work_sessions()
           if callback?
              callback()
   

   

   show_filled_main_modal = (action)->
      if action == "edit"
         $("#main_modal_delete").css("display","inline")
      else
         $("#main_modal_delete").css("display","none")
   
      $("#main_page_modal_when_empty").css("display","none")
      $("#main_page_modal_when_filled").css("display","inline")

      show_appointment_string()

      if $("#main_page_modal").data("token")?
        show_save_and_invite_buttons()
      else
        get_appointment_token(null,null, (token)->
          $("#main_page_modal").data("token",token)
          show_save_and_invite_buttons()	
          )

   show_appointment_string = ->
      day = $.datepicker.parseDate('yy-mm-dd', $(".main_modal_day.btn-primary").data("day"))
      appointment_str = to_appointment_string(
        day, 
        $("#date_main_modal_start").val(),
        $("#date_main_modal_end").val())
      $("#appointment_str").html(appointment_str)

   show_save_and_invite_buttons = ->
      $("#main_modal_invite").css("display","inline")
      $("#main_modal_save").css("display","inline")
   
   show_empty_main_modal = ->
      $("#main_page_modal_when_empty").css("display","inline")
      $("#main_page_modal_when_filled").css("display","none")

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
     name =  "Einladung zum gemeinsamen Lernen: " + $("#appointment_str").html()     
     message = "message"
     token = $("#main_page_modal").data("token")
     link = $("#urls").data("appointment_url")+"?token="+token
     fb_popup(name, message, link)	

   $("#main_modal_delete").click (event) ->
      [start_time, end_time] = from_day_and_hours_to_dates(
         $(".main_modal_day.btn-primary").data("day"), 
         $("#date_main_modal_start").val(),
         $("#date_main_modal_end").val())
      data = 
        start_time: start_time
        end_time: end_time
      $.ajax
        url: $("#urls").data("calendar_remove_events_by_time_url"),
        data: data,
        type: 'POST',
        statusCode:
          200: (x)->
            console.log x.responseText
            txt = "Der Termin wurde gelöscht."
            notice_html = "<div  class='alert alert-success'>"+txt+"</div>"
            $("#notice").html(notice_html)
            reload_my_work_sessions()
   
   $("#main_modal_save").click ->
      console.log $(".main_modal_day.btn-primary")
      token = $("#main_page_modal").data("token")
   
      [start_time, end_time] = from_day_and_hours_to_dates(
         $(".main_modal_day.btn-primary").data("day"), 
         $("#date_main_modal_start").val(),
         $("#date_main_modal_end").val())
      save_appointment(token, start_time, end_time, (response)->
         console.log response)
   
   
   $('#main_page_modal').bind('hidden', ->
      show_empty_main_modal())
   

   

   
   
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
          url = $("#data").data("base_url")+'/events.json' 
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
       # eventNew : (calEvent, event, FreeBusyManager, calendar)-> 
       #   if calEvent.userId>0
       #      $(calendar).weekCalendar('removeEvent',calEvent.id)
       #   else
       #     start_time = calEvent.start
       #     end_time = calEvent.end 
       #     if start_time > end_time
       #       $(calendar).weekCalendar('removeEvent',calEvent.id)
       #     else
       #       show_appointment_modal_and_get_token(start_time,end_time)
       #
        eventMouseover: (event,element,domEvent) ->
            if event.userId>0
             $(domEvent.target).attr("rel","popover")
             title = "<center>"+event.start.getHours()+":00 </center><br><table class='table'>"+event.name+"</table>"
             $(domEvent.target).attr("data-title",title)
             $(domEvent.target).popover("show"))
     
      #
      #  eventClick : (calEvent, event) ->
      #    if calEvent.userId==0        
      #      data = 
      #        event: calEvent.id
      #      $.ajax
      #        url: $("#data").data("base_url")+'/remove_event'
      #        data: data,
      #        type: 'POST',
      #     #   beforeSend: (xhr) -> 
      #     #     xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      #        statusCode:
      #          200: ->
      #            $("#calendar").weekCalendar("refresh"))
      #
   
      			
                  
      			
      			
                  
   #  # ------------- functions specific appointment modal --------- #
   #  
   #
   #  
   #  show_appointment_modal_and_get_token = (start_time, end_time) ->
   #     get_appointment_token(start_time, end_time, (token)->          
   #         $("#appointment_modal").data("token", token)
   #         $("#save_appointment").css("display","inline"))
   #     fill_appointment_modal_with_dates(new Date(start_time),new Date(end_time))
   #     $('#appointment_modal').modal("show")
   #  
   #  fill_appointment_modal_with_dates = (start_time,end_time) ->
   #     day = new Date(start_time)
   #     day.setHours(0,0,0,0)
   #     $("#appointment_modal").data("day",day)
   #     $('#date_appointment_modal_start option').removeAttr('selected')
   #     $("#date_appointment_modal_start option[value='"+leading_zero(start_time.getHours())+"']").attr('selected',true)
   #     $('#date_appointment_modal_end option').removeAttr('selected')
   #     $("#date_appointment_modal_end option[value='"+leading_zero(end_time.getHours())+"']").attr('selected',true)
   #     appointment_str = getAppointmentString()
   #     $("#appointment_str").html(appointment_str)
   #  
   #
   #  
   #  $("#date_appointment_modal_start").change ->
   #     update_appointment_modal_after_change()
   #  $("#date_appointment_modal_end").change ->
   #     update_appointment_modal_after_change()
   #  
   #  update_appointment_modal_after_change = ->
   #    appointment_str = getAppointmentString()
   #    $("#appointment_str").html(appointment_str)
   #  
   #  $("#save_appointment").click ->
   #     token = $("#appointment_modal").data("token")
   #  
   #     [start_time, end_time] = from_day_and_hours_to_dates(
   #       $("#appointment_modal").data("day"), 
   #       $("#date_appointment_modal_start").val(),
   #       $("#date_appointment_modal_end").val())
   #  
   #     save_appointment(token, start_time, end_time)
   #  
   #     name =  "Einladung zum gemeinsamen Lernen: " + $("#appointment_str").html()     
   #     message = "message"
   #     link = $("#urls").data("appointment_url")+"?token="+token
   #     fb_popup(name, message, link)
   #  
   
      			
                  
      			
      			
                  
     
