// Generated by CoffeeScript 1.4.0
(function() {
  var got_input, got_submit, submit;

  got_input = false;

  got_submit = false;

  submit = function() {
    var url;
    if (got_submit) {
      return;
    }
    url = $('#url').val();
    return $.post('/', {
      url: url 
    }, function(zip_url) {
      $('#url').replaceWith('<a href="' + zip_url + '">' + $('#url').get(0).outerHTML + '</a>');
      $('#url').val(zip_url);
      $('#url').select();
      $('#url').attr('readonly', 'readonly');
      return got_submit = true;
    });
  };

  $(document).bind('keydown', function(e) {
    got_input = true;
    if ((e.keyCode === 83 && e.ctrlKey) || e.keyCode === 13) {
      e.preventDefault();
      return submit();
    } else if (e.keycode === 27) {
      return $(element).empty();
    }
  });

  $(document).bind('paste', function(e) {
    got_input = true;
    return setTimeout(submit, 0);
  });

  $(document).click(function() {
    if (got_input) {
      return submit();
    }
  });

  $(document).ready(function() {
    return $('#url').focus();
  });

}).call(this);
