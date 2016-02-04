# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  channel = '/questions'
  PrivatePub.subscribe '/questions', (data, channel) ->
    question = $.parseJSON(data['question'])
    author = $.parseJSON(data['author'])
    $('.questions-list').append(JST["questions/index"]({
      question: question,
      author: author
    }))

voteDvote = ->
  $(document.body).on 'ajax:success', '.question .question-devote-link', (e, data, status, xhr) ->
    console.log('question devote');
    response = undefined
    response = $.parseJSON(xhr.responseText)
    $('.question .votes_block').html response.message
voteLike = ->
  $(document.body).on 'ajax:success', '.question .question-like-link', (e, data, status, xhr) ->

    console.log('question like');
    response = undefined
    response = $.parseJSON(xhr.responseText)
    $('.question .votes_block').html response.message
voteDislike = ->
  $(document.body).on 'ajax:success', '.question .question-dislike-link', (e, data, status, xhr) ->
    console.log('question like');
    response = undefined
    response = $.parseJSON(xhr.responseText)
    $('.question .votes_block').html response.message


ready = ->
  voteDvote()
  voteLike()
  voteDislike()

$(document).ready(ready)




