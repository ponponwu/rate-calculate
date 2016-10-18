$(document).ready(function() {
  // $( "#draggable" ).draggable();
  var fromRate, toRate, transferAmount,
  refreshSelect = function (){
    fromRate = $('#from_rate option:selected').text();
    toRate = $('#to_rate option:selected').text();
    transferAmount = $('#amount').val() === '' ? 0 : $('#amount').val();
    $('.selected-message p').text('欲將' + transferAmount + fromRate + '換成' + toRate);
  },
  check = function (){
    var amount = $('#amount').val();
    if (amount=='' || isNaN(amount)){
      alert('請填入數字');
      $('#amount').val('');$('#amount').focus();
      return false;
    }
    return true;
  };


  $('select').select2({
    width: "90%"
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
  // 執行 //
  refreshSelect();
  $('#panel select').on('change', function(){
    refreshSelect();
  });

  $('#amount').on('keyup', function(){
    refreshSelect();
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
  $('.btn-exchange').on('click', function(){
    fromRate = $('#from_rate option:selected').val();
    fromSetting = fromRate;
    toRate = $('#to_rate option:selected').val();
    $('#from_rate').val(toRate).trigger('change');
    $('#to_rate').val(fromSetting).trigger('change');
  });




});
