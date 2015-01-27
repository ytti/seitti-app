inputChangeCBDelay = 400

$(document).ready ->
  registerDeviceChange()
  updateForm()

updateForm = ->
  updateInputFields

updateInputFields = ->
  device = $( '#devices' ).val()
  oldInputs = readInputFields()
  $.getJSON '/vars', { file: device, input: oldInputs },  (result) ->
    updateInputFieldsCB result, oldInputs

updateInputFieldsCB = (newFields, oldInputs) ->
  oldFields = (i for i of oldInputs)
  formChanged = false
  for field in oldFields
    continue if itemInArray field, newFields
    formChanged = true
    $( "[id='p_var_#{field}'" ).remove()
  for field in newFields
    continue if itemInArray field, oldFields
    formChanged = true
    addInputField field
  if formChanged
    $( '#submit').button 'disable'
    $( '#submit' ).removeClass('on').addClass 'off'
  else
    $( '#submit').button 'enable'
    $( '#submit' ).removeClass('off').addClass 'on'

readInputFields = ->
  inputValues = {}
  $( "[id^='var_']" ).each (index, inputValue) ->
    inputValues[inputValue['name']] = inputValue['value']
  inputValues

addInputField = (fieldName) ->
  $('#submit').before( """<p id='p_var_#{fieldName}'>
  <label for='#{fieldName}'>#{prettyName fieldName}</label>
  <input type='text' value='' id='var_#{fieldName}'
  name='#{fieldName}'\></p>""")
  registerVarChange("var_#{fieldName}")

# when device is changed from drop-down
registerDeviceChange = ->
  $( '#devices' ).change ->
    updateForm()

# when input fields change, after delay render input fields again
registerVarChange = (variable) ->
  $("##{variable}").bind 'input propertychange', (evt) ->
    return if window.event && event.type == 'propertychange'&& event.propertyName != 'value'
    window.clearTimeout($(this).data('timeout'))
    $(this).data 'timeout', setTimeout ->
      updateForm()
     , inputChangeCBDelay

# check if item exists in array
itemInArray = (want_item, array) ->
  for item in array
    return true if item == want_item
  false

# show pretty name for form variables
prettyName = (str) ->
  str = str.replace(/_/g, ' ')
  (word[0].toUpperCase() + word[1..-1] for word in str.split /\s+/).join ' '
