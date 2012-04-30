# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready( ->
  if $('#calendar').length>0
    start_day = new Date()
    base_url = $("#data").data("base_url")
    
    $("#single_calendar_button").click ->
      $(this).addClass("btn-primary")
      $("[name='friend_button']").removeClass("btn-primary")
      $("#all_friends_button").removeClass("btn-primary")
      $('#calendar').weekCalendar("refresh")

    $("#all_friends_button").click ->
      $(this).addClass("btn-primary")
      $("[name='friend_button']").removeClass("btn-primary")
      $("#single_calendar_button").removeClass("btn-primary")
      $('#calendar').weekCalendar("refresh")

    $("[name='friend_button']").click ->
      if $(this).hasClass("btn-primary")
        $(this).removeClass("btn-primary")
        if !$("[name='friend_button']").hasClass("btn-primary")
          $("#single_calendar_button").addClass("btn-primary")
      else
        $(this).addClass("btn-primary")
        $("#single_calendar_button").removeClass("btn-primary")
        $("#all_friends_button").removeClass("btn-primary")#
      $('#calendar').weekCalendar("refresh")

    getUsers = ->
      users = []
      if $("#single_calendar_button").hasClass("btn-primary")
      else if $("#all_friends_button").hasClass("btn-primary")
        users = "all"	
      else
        selected = $("[name='friend_button']").filter(".btn-primary") 
        users = ($(x).data("user_id") for x in selected)
      users


    eventToJqueryCalendarEvent = (event) ->
      end_time = new Date(event.start_time)
      console.log("end_time="+end_time)
      end_time = end_time.setHours(event_start_time.getHours()+1)
      console.log("end_time="+end_time)
      alert "end_time="+end_time
      jquery_calendar_event = 
        id: event.id
        start_time: event.start_time
        end_time: end_time

    eventsToJqueryCalendarEvents = (response) ->
     #console.log("eventsToJqueryCalendarEvents")	
     #events = (eventToJqueryCalendarEvent(e1) for e1 in response)
     #console.log(events)
     #jquery_events =
     #   options: 
     #     "showAsSeparateUser":true
     #     "users":["ben1","ben2"]
     #   events: events
     #console.log(jquery_events)
     #jquery_events
      e = 
           events:[
             "id":10182
             "start":"2012-04-28T08:00:00Z"
             "end":"2012-04-28T09:00:00Z"]   

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
      longMonths: $.datepicker.regional['de'].monthNames,
      data: (start, end, callback) ->
        url= base_url+'/get_events/'+getUsers()
        $.getJSON(url, start: null, end: null, (result) -> callback(result))
    # data: (start, end, callback) ->
    #   #start and end contain the start and end time of the calendar
    #   url= base_url+'/own_events'
    #   # returns a jQuery XMLHttpRequest (jqXHR) object
    #   jqXHR = $.getJSON(url, (result) -> callback(result))
    #   jqXHR.done(  (response) ->
    #     console.log("jqXHR.done")
    #     eventsToJqueryCalendarEvents(response))

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
            statusCode:
              200: ->
                $("#calendar").weekCalendar("refresh"))

)      
        