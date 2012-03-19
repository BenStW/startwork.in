# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready( ->
  if $('#calendar').length>0
    day_of_week = new Date().getDay()
    base_url = $("#data").data("base_url")
    $('#calendar').weekCalendar(
      timeslotsPerHour: 1,
      firstDayOfWeek: day_of_week,
      defaultEventLength: 1,
      height:  (calendar) ->
        h = $(window).height() #- $("h1").outerHeight(true)
        #console.log "height="+h
        h
      shortDays: $.datepicker.regional['de'].dayNamesShort, 
      longDays: $.datepicker.regional['de'].dayNames, 
      shortMonths: $.datepicker.regional['de'].monthNamesShort, 
      longMonths: $.datepicker.regional['de'].monthNames,
      data: base_url+'/all_events',	
      newEventText: "",  
      draggable: ->
        false
      resizable: ->
        false
      eventNew : (calEvent, event) -> 
        start_time = calEvent.start.toString() 
        end_time = calEvent.end.toString() 
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
        