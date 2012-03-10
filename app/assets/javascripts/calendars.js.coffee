# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready( ->
      e_ben = null
      $("#calendar").click (event) ->
        console.log event
        e_ben = event

		#a1 { position:absolute; top:35px; left:240px; width:150px; height:150px;
		 #     z-index:1; background-color:#ddf; }
        true
#	if	$('#calendar').length>0
      $.datepicker.regional['de']
      day_of_week = new Date().getDay()
      $('#calendar').weekCalendar(
        timeslotsPerHour: 1,
        firstDayOfWeek: day_of_week,
        defaultEventLength: 1,
        height:  (calendar) ->
          $(window).height() - $("h1").outerHeight(true)
        eventNew : (calEvent, event) -> 
          work_session_id = $("#work_session").data("work_session_id")	
          console.log event
          console.log calEvent	
          console.log("Created event for work_session "+work_session_id+" with start " + calEvent.start + " and end " + calEvent.end + ".")
          start_time = calEvent.start.toString("yyyy-MM-DD")
          data = 
            start_time:start_time
          console.log data

          $.ajax
            url: '/work_session/'+work_session_id+'/calendar/event_new',
            data: data,
            type: 'POST',
            success: (data) ->
              console.log data)
      $('#ben_good').click (event) ->
        console.log "---- BEGIN ben good ----"
        event = document.createEvent("MouseEvents")
        event.initEvent("click", true, false)        
#        console.log event
        element = document.getElementById("ben1")
        console.log element
        element.dispatchEvent(event)   
        console.log "---- END ben good ----"   

      $("#ben").click (event) ->
        console.log "---- BEGIN ben challenge ----"	
 #       event = document.createEvent("MouseEvents")
        #event.initMouseEvent("click", true, true, window, 0, 475, 230, 475, 230, false, false, false, false, 0, null)
 #       event.initEvent("click", true, false)        
 #       console.log event
#        element = $("html body div.container span#work_session div#calendar div.ui-widget div.wc-scrollable-grid table.wc-time-slots tbody tr.wc-grid-row-events td.ui-state-default div.wc-full-height-column")
        element = $(".wc-full-height-column.wc-day-column-inner.day-2")
        #element = $("#ben1")
        console.log element
        #element.dispatchEvent(event)
        e = new jQuery.Event("click")
        e.pageX = 10
        e.pageY = 100
        
 #     if e.isDefaultPrevented()
 #       console.log("default behaviour is disabled - 1")
 #     else
 #       console.log( "Default behavior is enabled - 1" )
 #     e.preventDefault()
 #     if e.isDefaultPrevented()
 #        console.log( "Default behavior is disabled - 2" )
 #     else
 #        console.log( "Default behavior is enabled - 2" )
 #     element.trigger(e)
       # element..triggerHandler()
        element.trigger(e_ben)
        console.log "---- END ben challenge ----"	

    #    d = $('#ben1')
     #   console.log d
     #   $('#ben1').trigger('click')
      jQuery("#ben1").click (event) ->
        console.log "this is BEN1"
        console.log event
#.trigger('click')
)
        