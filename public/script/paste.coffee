$(document).bind 'keydown', (e) ->
  if e.keyCode == 83 and e.ctrlKey
    e.preventDefault()
    paste = $('#paste').val()
    $.post '/', { paste: paste }, (data) ->
      window.location.replace data


$(document).ready ->
  $('#paste').focus()
