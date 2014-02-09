got_input  = false
got_submit = false
submit = ->
  return if got_submit
  url = $('#url').val()
  $.post '/', { url: url }, (zip_url) ->
    $('#url').replaceWith '<a href="' + zip_url + '">' + $('#url').get(0).outerHTML + '</a>'
    $('#url').val  zip_url
    $('#url').select()
    $('#url').attr 'readonly', 'readonly'
    got_submit = true

$(document).bind 'keydown', (e) ->
  got_input = true
  if (e.keyCode == 83 and e.ctrlKey) or
     e.keyCode == 13
    e.preventDefault()
    submit()
  else if e.keycode == 27
    $(element).empty()

$(document).bind 'paste', (e) ->
  got_input = true
  setTimeout submit, 0

$(document).click ->
  if got_input
    submit()

$(document).ready ->
  $('#url').focus()
