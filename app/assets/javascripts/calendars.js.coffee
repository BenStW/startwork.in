# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready( ->
  if $('#calendar').length>0
    day_of_week = new Date().getDay()
    $('#calendar').weekCalendar(
      timeslotsPerHour: 1,
      firstDayOfWeek: day_of_week,
      defaultEventLength: 1,
      height:  (calendar) ->
        $(window).height() - $("h1").outerHeight(true)
      firstDayOfWeek: 1, 
      shortDays: $.datepicker.regional['de'].dayNamesShort, 
      longDays: $.datepicker.regional['de'].dayNames, 
      shortMonths: $.datepicker.regional['de'].monthNamesShort, 
      longMonths: $.datepicker.regional['de'].monthNames,
   #   data: '/work_session/'+work_session_id+'/calendar/all_times'
	
      newEventText: "",      
      eventNew : (calEvent, event) -> 
        work_session_id = $("#work_session").data("work_session_id")	
        console.log("Created event for work_session "+work_session_id+" with start " + calEvent.start + " and end " + calEvent.end + ".")
        start_time = calEvent.start.toString("yyyy-MM-DD")
        data = 
          start_time:start_time
        console.log data
    
        $.ajax
          url: '/work_session/'+work_session_id+'/calendar/new_time',
          data: data,
          type: 'POST',
          success: (data) ->
            console.log data)
)
        