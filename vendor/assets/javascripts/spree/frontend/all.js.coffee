# This is a manifest file that'll be compiled into including all the files listed below.
# Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
# be included in the compiled file accessible from http://example.com/assets/application.js
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
#= require jquery
#= require jquery_ujs
#= require spree/frontend
#= require bootstrap-select.min

#= require_tree .
#= require spree/frontend/spree_auth
#= require spree/frontend/spree_i18n


Spree.ready ($) ->
  if ($ '#checkout_form_metodo_envio').is('*')

    metodo_envio_other = ($ 'input#order_metodo_envio_other')
    ($ 'input.metodo_envio').change ->
      update_metodo_envio_otros_text metodo_envio_other
    
    update_metodo_envio_otros_text = (metodo_envio_other) ->
      if metodo_envio_other.is(':checked')
        ($ 'input#order_metodo_envio_otros').prop 'disabled', false
      else
        ($ 'input#order_metodo_envio_otros').prop 'disabled', true

    update_metodo_envio_otros_text metodo_envio_other

    metodo_envio_mercado_envios = ($ 'input#order_metodo_envio_mercado_envios')
    metodo_envio_retiro_local = ($ 'input#order_metodo_envio_retiro_local')
    ($ 'input.metodo_envio').change ->
      update_metodo_envio_retiro_local()
    
    update_metodo_envio_retiro_local = ->
      if metodo_envio_retiro_local.is(':checked') || metodo_envio_mercado_envios.is(':checked')
        ($ '#shipping .inner input, #shipping .inner select').prop 'disabled', true
      else
        ($ '#shipping .inner input, #shipping .inner select').prop 'disabled', false

    setTimeout(->
      update_metodo_envio_retiro_local()
    , 1)



    order_use_billing = ($ 'input#order_use_billing')
    order_use_billing.change ->
      update_shipping_form_state order_use_billing

    update_shipping_form_state = (order_use_billing) ->
      if order_use_billing.is(':checked')
        ($ '#shipping .inner').hide()
        ($ '#shipping .inner input, #shipping .inner select').prop 'disabled', true
      else
        ($ '#shipping .inner').show()
        ($ '#shipping .inner input, #shipping .inner select').prop 'disabled', false
        Spree.updateState('s')

    update_shipping_form_state order_use_billing
  
  # Si el total de la factura es < 1000 entonces deshabilito los datos de facturacion si elige consumidor
  if $("#billing").attr('data-should-hide-billing') == 'yes'
    if ($ '#checkout_form_address').is('*')
      tipo_factura_consumidor_final = ($ 'input#order_tipo_factura_consumidor_final')
      ($ 'input.tipo_factura').change ->
        update_billing_enabled tipo_factura_consumidor_final
      
      update_billing_enabled = (tipo_factura_consumidor_final) ->
        if tipo_factura_consumidor_final.is(':checked')
          ($ '#billing .inner input, #billing .inner select').prop 'disabled', true
        else
          ($ '#billing .inner input, #billing .inner select').prop 'disabled', false

      update_billing_enabled tipo_factura_consumidor_final

