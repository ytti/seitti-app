gotFile = ->
  $('#upload').submit()


$(document).ready ->
  $('#file').change ->
    gotFile()
