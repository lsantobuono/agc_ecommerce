// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require spree/backend
//= require bootstrap
//= require summernote

//= require spree/backend/spree_i18n
//= require spree/backend/spree_volume_pricing

//= require jquery-ui/sortable
//= require jquery.mjs.nestedSortable.js

//= require jquery_nested_form
//= require_tree .



$(document).on('nested:fieldAdded', function(event){
  var field = event.field; 
  var select2_field = field.find('.select2');
  select2_field.select2();
  $(".variant_autocomplete").variantAutocomplete();
})

$(document).ready(function() {
  var order_set_billing_input = $('input#order_set_billing');
  if( order_set_billing_input.is('*') ) {
    var order_set_billing = function () {
      if (order_set_billing_input.is(':checked')) {
        $('#billing').show();
        $('#billing input').attr('disabled', null);
        $('#billing select').attr('disabled', null);
      } else {
        $('#billing').hide();
        $('#billing input').attr('disabled', '1');
        $('#billing select').attr('disabled', '1');
      }
    };

    order_set_billing_input.click(function() {
      order_set_billing();
    });

    order_set_billing();
  }
});
//= require spree/backend/spree_print_invoice
