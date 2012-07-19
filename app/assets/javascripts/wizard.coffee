$(document).ready ->
   if $("#wizard0").length>0
      
     if $("#wizard0").data("dont_show_wizard")
     else
       $("#wizard0").modal
          show: true
     
     
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

     $('.modal-backdrop').css("opacity",0.4)