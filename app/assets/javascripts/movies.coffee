$(document).on 'turbolinks:load', ->
  total = $('.answer-pool .answer').length

  # allow names to be dragged
  $('.answer').draggable
    revert: true
    revertDuration: 0

  # handle name dropped on actor
  $('.actor').droppable
    drop: (event, ui) ->
      # if actor already has a name, swap it with the dropped one
      ui.draggable.parent().append($(this).find('.answer'))
      $(this).find('.answer-slot').append(ui.draggable)

      # if all names have been assigned, show the submit button
      if $('.answer-pool .answer').length == 0
        $('.submit').removeClass('hidden')
      else
        $('.submit').addClass('hidden')

  # allow names to be dropped back into the pool
  $('.answer-pool').droppable
    drop: (event, ui) ->
      $('.answer-pool').append(ui.draggable)

  $('.submit').on 'click', ->
    $('.answer').draggable( 'disable' )
    score = 0

    # check answers and tally score
    $('.actor').each (idx) ->
      key = parseInt($(this).find('.answer').attr('data-key'))
      if (key == idx)
        score += 1
        $(this).addClass('correct')
      else
        $(this).addClass('incorrect')

    $('.answer-pool').addClass('hidden')
    $('.results .score').html(score + '/' + total)
    $('.results').removeClass('hidden')
