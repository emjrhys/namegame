$(document).on 'turbolinks:load', ->
  total = $('.answer-pool .answer').length

  # allow names to be dragged
  $('.answer').draggable
    cursor: 'grabbing'
    revert: true
    revertDuration: 0

  # handle name dropped on actor
  $('.actor').droppable
    hoverClass: 'drop-hover'
    drop: (event, ui) ->
      # if actor already has a name, swap it with the dropped one
      ui.draggable.parent().append($(this).find('.answer'))
      $(this).find('.answer-slot').append(ui.draggable)

      # if all names have been assigned, show the submit button
      if $('.answer-pool .answer').length == 0
        $('.submit').removeClass('hidden')
      else
        $('.submit').addClass('hidden')

  # allow names to be dropped back into the pool and hide submit
  $('.answer-pool').droppable
    drop: (event, ui) ->
      $('.answer-pool').append(ui.draggable)
      $('.submit').addClass('hidden')

  $('.submit').on 'click', ->
    $('.answer').draggable( 'disable' )
    score = 0

    # check answers and tally score
    $('.actor').each (idx, elem) ->
      actorKey = parseInt($(elem).attr('data-key'))
      nameKey = parseInt($(elem).find('.answer').attr('data-key'))

      if (actorKey == nameKey)
        score += 1
        $(elem).addClass('correct')
      else
        $(elem).addClass('incorrect')

      setTimeout updateScore, 500 * idx, score

    if (score >= 5)
      $('.results .score').addClass('great-score')
    else if (score <= 1)
      $('.results .score').addClass('bad-score')

    $('.answer-pool').addClass('hidden')
    $('.results').removeClass('hidden')

  updateScore = (score) ->
    console.log(score)
    $('.results .score').html(score + '/' + total)
