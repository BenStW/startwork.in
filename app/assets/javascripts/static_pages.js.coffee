

$(document).ready ->

   # The Javascript for the 3 columns and the modal was moved to calendar.js.coffee

   $("#video_modal_button").click ->
       $('#video_modal').modal("show")

   $("#appointment_carousel").carousel
       interval: false

   $("#wizard0").modal
        show: true

   $('.modal-backdrop').css("opacity",0.4)

   $(".continue_button").click ->
        $("[id^=explain]").removeClass("active_element")
        $("[id^=wizard]").removeClass("active_modal")
        element_id=$(this).data("activate_element")
        modal_id=$(this).data("activate_modal")
        $(element_id).addClass("active_element")
        $(modal_id).addClass("active_modal")

   $("#start_work_button").click ->
       $('#start_work').modal("show")
       $('.modal-backdrop').height(0)
       $('#start_work').height(max)
       $('.modal-arrow').css("top",(max - 75) / 2)   #funktioniert nicht mehr?!!

   adjust_height = ->
      console.log('adjust_height')
      $('.column_same_height').removeAttr('height')
      heights= $(".column_same_height").map(->
            return $(this).outerHeight(true)).get()
      Array.max = (array) ->
        return Math.max.apply(Math, array)
      max = Array.max(heights)
      $('.column_same_height').height(max)

   if $('.column_same_height').length>0
      adjust_height()

   $('#problems').on('shown',-> $('.column_same_height').height(max))

   $('#flash_test_button').click ->
       playerVersion= swfobject.getFlashPlayerVersion()
       output= "You have Flash player " + playerVersion.major + "." + playerVersion.minor + "." + playerVersion.release + " installed"
       alert(output)