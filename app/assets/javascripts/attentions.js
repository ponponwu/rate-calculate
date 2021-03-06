


(function($) {
  $.fn.modal_success = function(){
    // close modal
    this.modal('hide');
    // clear form input elements
    // todo/note: handle textarea, select, etc
    this.find('form input[type="number"]').val('');
    // clear error state
    this.clear_previous_errors();
  };
  $.fn.render_form_errors = function(errors){
    $form = this;
    this.clear_previous_errors();
    model = this.data('model');
    // show error messages in input form-group help-block
    $.each(errors, function(field, messages){
      $input = $('input[name="' + model + '[' + field + ']"]');
      $input.closest('.form-group').addClass('has-error').find('.help-block').html( messages.join(' & ') );
    });
  };
  $.fn.render_login_errors = function(errors){
    $form = this;
    // this.clear_login_errors();
    // model = this.data('model');
    $errorMessages = $('#devise-error-message p');
    $errorMessages.html( errors );
  };


  $.fn.clear_previous_errors = function(){
    $('.form-group.has-error', this).each(function(){
      $('.help-block', $(this)).html('');
      $(this).removeClass('has-error');
    });
  }
}(jQuery));
