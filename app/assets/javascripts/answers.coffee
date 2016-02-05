# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.answers').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $("#answer-edit-"+answer_id).show()


voteDvote = ->
  $(document.body).on 'ajax:success', '.answers .answer-devote-link', (e, data, status, xhr) ->
    response = undefined
    response = $.parseJSON(xhr.responseText)
    $('.answers .answer-box-id-' + response.voted_id + ' .votes_block').html response.message
voteLike = ->
  $(document.body).on 'ajax:success', '.answers .answer-like-link', (e, data, status, xhr) ->
    response = undefined
    response = $.parseJSON(xhr.responseText)
    $('.answers .answer-box-id-' + response.voted_id + ' .votes_block').html response.message
voteDislike = ->
  $(document.body).on 'ajax:success', '.answers .answer-dislike-link', (e, data, status, xhr) ->
    response = undefined
    response = $.parseJSON(xhr.responseText)
    $('.answers .answer-box-id-' + response.voted_id + ' .votes_block').html response.message


ready = ->
  voteDvote()
  voteLike()
  voteDislike()

$(document).ready(ready)
