

$(document).ready ->
   #$("[id^=explain]").addClass("active_element")


   addDot = ->
      $("#login_button").append(".")
	
   $("#login_button").click (event )->
     $("#login_button").html("verbinde")
    # event.preventDefault()
     for sec in [1..20]
       setTimeout(addDot,sec*1000)

	  # <form accept-charset="UTF-8" action="/kamera.20" class="edit_camera" id="edit_camera_20" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="✓"><input name="_method" type="hidden" value="put"><input name="authenticity_token" type="hidden" value="cGXwM2F5HR3B0MZDZ52+bhen0IfuOUdSNTtd7xgtPu8="></div>
	  #     <input class="btn btn-danger btn-large" data-camera-success="null" id="join_work_session_after_info" name="commit" type="submit" value="Jetzt Starten!">
	  #
	  #          <a href="#" class="btn btn-large" data-dismiss="modal">Abbrechen</a>
	  #             <label class="checkbox" style="width: 200px;float: right;margin-right: 20px;margin-top: 10px;">
	  # 			    <input name="camera[dont_show_info]" type="hidden" value="0"><input id="camera_dont_show_info" name="camera[dont_show_info]" type="checkbox" value="1"> Diese Seite nicht mehr anzeigen
	  #             </label>
	  # </form>
	
   $(".dont_show_tour").click ->
      console.log "dont_show_tour"
      data =
        camera :
          dont_show_wizard : 1
      console.log data
      $.ajax
        url: $("#urls").data("camera_url"),
        data: data,
        type: 'PUT',
        statusCode:
          200: (response)->
            console.log "Das Ausblenden des Wizards wurde gespeichert"
      
   # The Javascript for the 3 columns and the modal was moved to calendar.js.coffee

   $("#video_modal_button").click ->
       $('#video_modal').modal("show")


   $("#appointment_carousel").carousel
       interval: false

   if $("#wizard0").data("dont_show_wizard")
   else
     $("#wizard0").modal
        show: true

   # this is only the initial backdrop of the first modal
   $('.modal-backdrop').css("opacity",0.4)

   $(".continue_button").click ->
        $("[id^=explain]").removeClass("active_element")
        #$("[id^=wizard]").removeClass("active_modal")
        $("[id^=wizard]").modal("hide")
        element_id=$(this).data("activate_element")
        modal_id=$(this).data("activate_modal")
        $(modal_id).modal("show")
        $(element_id).addClass("active_element")
        $('.modal-backdrop').css("opacity",0.4)
       # $(modal_id).addClass("active_modal")

   $("#start_work_button").click -> 
        if $(this).data("dont_show_info")
           if $(this).data("camera-success")
              console.log "popup_work_session"
              popup_work_session()
           else
              window.location = $("#urls").data("camera_url")
        else
            $('#start_work').modal("show")
            $('.modal-backdrop').height(0)
            max = get_max()
            $('#start_work').height(max)
            $('.modal-arrow').css("top",(max - 75) / 2)   #funktioniert nicht mehr?!!        


   get_max = ->
      heights= $(".column_same_height").map(->
            return $(this).outerHeight(true)).get()
      Array.max = (array) ->
        return Math.max.apply(Math, array)
      max = Array.max(heights)

   adjust_height = ->
      $('.column_same_height').removeAttr('height')
      max = get_max()

      $('.column_same_height').height(max)

   if $('.column_same_height').length>0
      adjust_height()

   $('#problems').on('shown',-> 
      $(".column_same_height").height("")
      adjust_height())

   $('#problems').on('hidden',-> 
      $(".column_same_height").height("")
      adjust_height())


   popup_work_session = ->
     video_url = $("#urls").data("group_hour_url")
     info_url = $("#urls").data("info_for_group_hour_url")
     screenX = screen.availWidth
   
     screenY = screen.availHeight
     taskbar = 48
     browser_row = 56
     feedback = 35
     reduced_screenY = screenY - taskbar - browser_row - feedback
   
     timer = 48
     to_speak = 64
     name = 12
     video_border =  12
   
     window_width = ((reduced_screenY - to_speak - timer) / 3) - name - video_border
   
     popup_start = screenX - window_width
     popUp = window.open(video_url,
        'StartWork',
        'width='+window_width+',height='+screenY+',location=no,menubar=no,toolbar=no,scrollbars=yes,resizable=yes,left='+popup_start+',top=0')
     if (!popUp)
         popup_not_successful()
     else
       popUp.onload = ->
        f = ->
           if (popUp.screenX is 0)
              popup_not_successful()
           else	
              if info_url?
                window.location = info_url
        setTimeout(f,0)
    
   popup_not_successful = ->
        alert "Das Video-Fenster konnte nicht geöffnet werden. Für StartWork musst du Popups erlauben."
   
   $('#join_work_session_after_camera_test').click (event)-> 
        popup_work_session()

   $('#join_work_session_after_info').click (event)-> 
      if $(this).data("camera-success")
         popup_work_session()
      else
         window.location = camera_url

   if $("#flash_version").length>0
      playerVersion= swfobject.getFlashPlayerVersion()
      flash_version =  playerVersion.major + "." + playerVersion.minor + "." + playerVersion.release
      if playerVersion.major < 11
         $("#flash_version").html(flash_version)
      else
         $("#flash_version_alert").css("display","none")
