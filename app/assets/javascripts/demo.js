$(document).ready(function() {
  // $( "#draggable" ).draggable();
  $('select').select2({
    width: "60%"
  });
  $('a.country').on('click', function(){
    $.ajax({
      url: '/countries/select',
      type: 'POST',
      dataType: 'script',
      data: {
        country: $(this).data('value'),
        country_cn: $(this).text()
      }
    }).done(function(data) {
    });
  });
  $('#btnTransfer').on('click', function(){
    if(check()){
      $.ajax({
        url: '/countries/calculate',
        type: 'POST',
        dataType: 'script',
        data: {
          _from: $('#from_rate').val(),
          _to: $('#to_rate').val(),
          amount: $('#amount').val()
        }
      })
    }
  });

  function check(){
    var amount = $('#amount').val();
    if (amount=='' || isNaN(amount)){
      alert('請填入數字');
      $('#amount').val('');$('#amount').focus();
      return false;
    }
    return true;
  }


});
