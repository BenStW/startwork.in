# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
   if $("#calendar").length > 0
	        
       start_day = new Date()
       base_url = $("#data").data("base_url")

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
         console.log events
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
            url = base_url+'/events.json' 
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
             if event.userId>0
               $(domEvent.target).attr("rel","popover")
               title = "<center>"+event.start.getHours()+":00 </center><br><table class='table'>"+event.name+"</table>"
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


					
                    
					
					
                    
					
					
                    
					
					
                    
      