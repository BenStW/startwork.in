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

   $("#display_picker_adjust_height").click ->
      $("#appointment_on_welcomepage").css("display","inline")
      myheight = 0
      $('#welcome_box').removeAttr('height')
      $('#welcome_box').css('height',"")
      myheight = $('#welcome_content').outerHeight()
      $('#welcome_box').height(myheight)    

   if $("#canvas").length>0
    # console.log "redirect to "+$("#urls").data("root_url")
     console.log "params"+$("#canvas").data("params")
    # window.location = $("#urls").data("root_url")

   if $("#canvas2").length>0
     console.log "redirect to "+$("#urls").data("root_url")
     console.log "params"+$("#canvas").data("params")
     window.location = $("#urls").data("root_url")

#<script type='text/javascript'>top.location.href = 'URL';</script>

