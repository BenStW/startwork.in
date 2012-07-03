
$(document).ready ->
   if $('.column_same_height').length>0
      heights= $(".column_same_height").map(->
          return $(this).outerHeight(true)).get()
      console.log "Heights="+heights
      Array.max = (array) ->
        return Math.max.apply(Math, array)
      console.log "Set all heights to max="+Array.max(heights)
      max = Array.max(heights)
      $('.column_same_height').height(max)
      console.log $('.column_same_height')
      $("#launch_modal_button").click ->
        $('#main_page_modal').modal("show")
        $('.modal-backdrop').height(0)
        $('#main_page_modal').height(max)
        console.log(max)
    
   $("#video_modal_button").click ->
       $('#video_modal').modal("show")