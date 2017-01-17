#debugger
#if @doc.tipo_factura == "factura_a"
#  render 'spree/printables/shared/invoice/base_a', doc: @doc
#elsif @doc.tipo_factura == "factura_b"
#  render 'spree/printables/shared/invoice/base_b', doc: @doc
#elsif @doc.tipo_factura == "consumidor_final"
#  render 'spree/printables/shared/invoice/base_cf', doc: @doc
#end