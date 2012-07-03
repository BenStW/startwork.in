
$(document).ready ->
   if $('.column_same_height').length>0
      heights= $(".column_same_height").map(->
          return $(this).outerHeight(true)).get()
      Array.max = (array) ->
        return Math.max.apply(Math, array)
      max = Array.max(heights)
      $('.column_same_height').height(max)

      $("#launch_modal_button").click ->
        $('#main_page_modal').modal("show")
        $('.modal-backdrop').height(0)
        $('#main_page_modal').height(max)
    
   $("#video_modal_button").click ->
       $('#video_modal').modal("show")