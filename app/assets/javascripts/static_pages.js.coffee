$(document).ready ->
	
   $(".dont_show_tour").click ->
      console.log "dont_show_tour"
      data =
        camera :
          dont_show_wizard : 1
      $.ajax
        url: $("#urls").data("camera_url"),
        data: data,
        type: 'PUT',
        statusCode:
          200: (response)->
            console.log "Das Ausblenden des Wizards wurde gespeichert"
      
   $("#video_modal_button").click ->
       $('#video_modal').modal("show")


   $(".remove_height_from_content_and_set_it_to_box").click ->
     $('#welcome_content').css("height", "")
     height=$("#welcome_content").outerHeight()
     console.log "set height from "+$("#welcome_box").height()+" to "+height
     $("#welcome_box").height(height)

   $(".adjust_height_on_welcome_page").click ->
      $("#appointment_on_welcomepage").css("display","block")
      myheight = 0
      $('#welcome_box').removeAttr('height')
      $('#welcome_box').css('height',"")
      myheight = $('#welcome_content').outerHeight()
      $('#welcome_box').height(myheight)    

   if $("#canvas").length>0
     if $("#canvas").data("appointment-id")?
       appointment_id = $("#canvas").data("appointment-id")
       top.location.href = "http://startwork.in/verabredungen/"+appointment_id
     else
       top.location.href = "http://startwork.in"
  
