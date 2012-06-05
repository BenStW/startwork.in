# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
   if $("#calendar").length > 0
	        
       start_day = new Date()
       base_url = $("#data").data("base_url")

    #   $("[rel=popover]").popover()

       $("#send_invitation").click ->
            $('#send_invitation_modal').modal("show")
       
       $("#send_invitation_confirmation").click ->
          url = $(this).attr("url")
          request = $.ajax
             url: url
             type: 'GET'
             success: (data) -> 
                console.log data
        
       backendEventToFrontendEvent = (backend_event) ->
         start_time = new Date(backend_event.start_time)
         end_time = new Date(backend_event.start_time)
         end_time.setHours(start_time.getHours()+1)
         if backend_event.user.id==$("#data").data("my_user_id")
             column_id = 0
         else
             column_id = 1
         jquery_calendar_event = 
           id: backend_event.id
           start: start_time
           end: end_time
           userId: column_id
           name: backend_event.user.first_name + " " + backend_event.user.last_name
       
       merge_events_of_same_time = (frontend_events) ->
         own_events = []
         other_events = []
         for event in frontend_events
           if event.userId==0
             own_events.push(event)
           else
             other_events.push(event)
         other_events = other_events.sort(
             (a,b) ->  a.start-b.start)
         merged_other_events = []
         last_event = other_events.shift()
         for event in other_events
           # console.log(event.start + " - " + last_event.start)
            if Date.parse(event.start) == Date.parse(last_event.start)
              event.name = last_event.name+"<br>"+event.name
            else
            #  console.log(Date.parse(event.start)+"<>"+Date.parse(last_event.start))
              merged_other_events.push(last_event)
            last_event = event
         merged_other_events.push(event)  
         own_events.concat(merged_other_events)
       #  own_events.concat(other_events)


       backendEventsToFrontendEvents = (backend_events) ->
         user2column_hash = []
         frontend_events = (backendEventToFrontendEvent(backend_event) for backend_event in backend_events)
       #  console.log frontend_events
         frontend_events = merge_events_of_same_time(frontend_events)
       #  console.log frontend_events
         calendar_events = 
           options: 
             "showAsSeparateUser":true
             "users": ["Ich","Freunde"]	
           events: frontend_events
       
        $('#calendar').weekCalendar(
          date:  start_day,
          timeslotsPerHour: 1,
          firstDayOfWeek:  start_day.getDay(), 
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
            url = base_url+'/events' 
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
            if calEvent.userId>0
               $(calendar).weekCalendar('removeEvent',calEvent.id)
            else
              start_time = calEvent.start.toString() 
              end_time = calEvent.end.toString() 
              if start_time > end_time
                $(calendar).weekCalendar('removeEvent',calEvent.id)
              else	      
                data = 
                  start_time:start_time
                  end_time:end_time
                $.ajax
                  url: base_url+'/new_event',
                  data: data,
                  type: 'POST',
              #    beforeSend: (xhr) -> 
               #     xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
                  statusCode:
                    200: ->
                      $("#calendar").weekCalendar("refresh")

          eventMouseover: (event,element,domEvent) ->
             console.log("EVENT")
             if event.userId>0
              # console.log(event)
              # console.log(element)
               console.log(domEvent)
               $(domEvent.target).attr("rel","popover")
               title = event.start.getHours()+":00 <br>"+event.name
               $(domEvent.target).attr("data-title",title)
               $(domEvent.target).popover("show")

      
          eventClick : (calEvent, event) ->
            if calEvent.userId==0        
              data = 
                event: calEvent.id
              $.ajax
                url: base_url+'/remove_event'
                data: data,
                type: 'POST',
             #   beforeSend: (xhr) -> 
             #     xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
                statusCode:
                  200: ->
                    $("#calendar").weekCalendar("refresh"))
      