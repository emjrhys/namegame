$(document).on 'turbolinks:load', ->
  $('#namegame .answers span').draggable { revert: false }
  $('#namegame .actors li').droppable 
