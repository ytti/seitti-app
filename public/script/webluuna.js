// Generated by CoffeeScript 1.4.0
(function() {
  var addInputField, inputChangeCBDelay, itemInArray, prettyName, readInputFields, registerDeviceChange, registerVarChange, updateForm, updateInputFields, updateInputFieldsCB;

  inputChangeCBDelay = 400;

  $(document).ready(function() {
    registerDeviceChange();
    return updateForm();
  });

  updateForm = function(submit) {
    return updateInputFields(submit);
  };

  updateInputFields = function(submit) {
    var device, oldInputs;
    device = $('#devices').val();
    oldInputs = readInputFields();
    return $.getJSON('/vars', {
      file: device,
      input: oldInputs
    }, function(result) {
      return updateInputFieldsCB(result, oldInputs, submit);
    });
  };

  updateInputFieldsCB = function(newFields, oldInputs, submit) {
    var field, formChanged, i, oldFields, _i, _j, _len, _len1;
    oldFields = (function() {
      var _results;
      _results = [];
      for (i in oldInputs) {
        _results.push(i);
      }
      return _results;
    })();
    formChanged = false;
    for (_i = 0, _len = oldFields.length; _i < _len; _i++) {
      field = oldFields[_i];
      if (itemInArray(field, newFields)) {
        continue;
      }
      formChanged = true;
      $("[id='p_var_" + field + "'").remove();
    }
    for (_j = 0, _len1 = newFields.length; _j < _len1; _j++) {
      field = newFields[_j];
      if (itemInArray(field, oldFields)) {
        continue;
      }
      formChanged = true;
      addInputField(field);
    }
    if (formChanged) {
      $('#submit').attr('disabled', 'disabled');
      return $('#submit').removeClass('on').addClass('off');
    } else {
      $('#submit').removeAttr('disabled');
      return $('#submit').removeClass('off').addClass('on');
    }
  };

  readInputFields = function() {
    var inputValues;
    inputValues = {};
    $("[id^='var_']").each(function(index, inputValue) {
      return inputValues[inputValue['name']] = inputValue['value'];
    });
    return inputValues;
  };

  addInputField = function(fieldName) {
    $('#submit').before("<p id='p_var_" + fieldName + "'>\n<label for='" + fieldName + "'>" + (prettyName(fieldName)) + "</label>\n<input type='text' value='' id='var_" + fieldName + "'\nname='" + fieldName + "'\></p>");
    return registerVarChange("var_" + fieldName);
  };

  registerDeviceChange = function() {
    return $('#devices').change(function() {
      return updateForm();
    });
  };

  registerVarChange = function(variable) {
    return $("#" + variable).bind('input propertychange', function(evt) {
      if (window.event && event.type === 'propertychange' && event.propertyName !== 'value') {
        return;
      }
      window.clearTimeout($(this).data('timeout'));
      return $(this).data('timeout', setTimeout(function() {
        return updateForm();
      }, inputChangeCBDelay));
    });
  };

  itemInArray = function(want_item, array) {
    var item, _i, _len;
    for (_i = 0, _len = array.length; _i < _len; _i++) {
      item = array[_i];
      if (item === want_item) {
        return true;
      }
    }
    return false;
  };

  prettyName = function(str) {
    var word;
    str = str.replace(/_/g, ' ');
    return ((function() {
      var _i, _len, _ref, _results;
      _ref = str.split(/\s+/);
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        word = _ref[_i];
        _results.push(word[0].toUpperCase() + word.slice(1));
      }
      return _results;
    })()).join(' ');
  };

}).call(this);