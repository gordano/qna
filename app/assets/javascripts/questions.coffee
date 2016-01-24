# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.question').bind 'ajax:success', (e, data, status, xhr) ->
    response = undefined
    response = $.parseJSON(xhr.responseText)
    $('.question .votes_block').html response.message



