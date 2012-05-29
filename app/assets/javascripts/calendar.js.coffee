# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
   if $("#calendar").length > 0
        
       start_day = new Date()
       base_url = $("#data").data("base_url")
       
       backendEventToFrontendEvent = (frontend_event,user2column_hash) ->
         start_time = new Date(frontend_event.start_time)
         end_time = new Date(frontend_event.start_time)
         end_time.setHours(start_time.getHours()+1)
         if frontend_event.user_id==$("#data").data("my_user_id")
             column_id = 0
         else
             column_id = 1
         jquery_calendar_event = 
           id: frontend_event.id
           start: start_time
           end: end_time
           userId: column_id 
       
       
       getUser2Column_UserNames = () ->
         user_names = []
         user2column_hash = {}
         if $("#all_friends_button").hasClass("btn-primary")
            user_names = [$("#data").data("my_user_name"), "all"]
         else if not $("#single_calendar_button").hasClass("btn-primary")
            selected_users = selectedUsers() #returns selected_user_ids and selected_user_names, which correspond to each other in order
            user2column_hash = selected_users[0]
            selected_user_names = selected_users[1]
            user_names = [$("#data").data("my_user_name")] #put own name at the beginning
            user_names = user_names.concat(selected_user_names)
         [user2column_hash,user_names]	
       
       # The user has three possibilities to view calendar events:
       # 1) showing only his calendar events --> $("#single_calendar_button") is pressed
       # 2) showing his calendar events (colomn 0) and these of specific friends (column>0)
       # 3) showing all calendar events of him (column 0) and all his friends (column 1)
       # The columns are titled as follows:
       # 1) no title
       # 2) own name (column 0) and the specific names per column (column>1). These names must be get from page and 
       #    not per calendar event from the backend, as not all friends have calendar events defined
       # 3) own name (column 0) and "all" (column 1)
       # It is important that the column name matches to calendar event. This is only in case 2) a challenge.
       # Therefore user_names and user2column_hash is provided by one method
      
       backendEventsToFrontendEvents = (backend_events) ->
         user2column_hash = []
         frontend_events = (backendEventToFrontendEvent(backend_event,user2column_hash) for backend_event in backend_events)
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
                  beforeSend: (xhr) -> 
                    xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
                  statusCode:
                    200: ->
                      $("#calendar").weekCalendar("refresh")
      
      
          eventClick : (calEvent, event) ->
            if calEvent.userId==0        
              data = 
                event: calEvent.id
              $.ajax
                url: base_url+'/remove_event'
                data: data,
                type: 'POST',
                beforeSend: (xhr) -> 
                  xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
                statusCode:
                  200: ->
                    $("#calendar").weekCalendar("refresh"))
      