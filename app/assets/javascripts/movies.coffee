$(document).on 'turbolinks:load', ->
  $('#namegame .answer').draggable
    revert: true
    revertDuration: 0
    
  $('#namegame .actor').droppable
    drop: (event, ui) ->
      $('.answer-pool').append($(this).find('.answer'))
      $(this).append(ui.draggable)
