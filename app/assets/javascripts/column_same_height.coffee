$(document).ready ->
   if $(".column_same_height").length>0
      
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
      
      $('#start_work').on('shown', ->
         $('.modal-backdrop').height(0)
         max = get_max()
         $('#start_work').height(max)
         $('.modal-arrow').css("top",(max - 75) / 2))     
      
      $('#problems').on('shown',-> 
         $(".column_same_height").height("")
         adjust_height())
      
      $('#problems').on('hidden',-> 
         $(".column_same_height").height("")
         adjust_height())

      $('#main_page_modal').on('shown', ->
         max = get_max()
         $('.modal-backdrop').height(0)
         $('#main_page_modal').height(max)
         $('.modal-arrow').css("top",(max - 75) / 2))

      adjust_height()

      
      
      