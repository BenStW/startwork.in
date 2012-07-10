

$(document).ready ->

   # The Javascript for the 3 columns and the modal was moved to calendar.js.coffee

   $("#video_modal_button").click ->
       $('#video_modal').modal("show")


   $("#appointment_carousel").carousel
       interval: false

   $("#wizard0").modal
        show: true

   $(".continue_button").click ->
        $("[id^=explain]").removeClass("active_element")
        $("[id^=wizard]").removeClass("active_modal")
        element_id=$(this).data("activate_element")
        modal_id=$(this).data("activate_modal")
        $(element_id).addClass("active_element")
        $(modal_id).addClass("active_modal")