# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.answers').on 'click', '.edit-answer-link', (e) ->
    console.log('click')
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $("#answer-edit-"+answer_id).show()

  $('.answers').bind 'ajax:success', (e, data, status, xhr) ->
    response = undefined
    response = $.parseJSON(xhr.responseText)
    console.log(response.voted_id);

    $('.answers .answer-box-id-' + response.voted_id + ' .votes_block').html response.message
