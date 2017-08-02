bill_address = printable.bill_address
ship_address = printable.ship_address

pdf.move_down 2

dataAddress = nil
dataShip = nil

if (bill_address != nil)
  address_cell_billing  = pdf.make_cell(content: "#{Spree.t(:billing_data)} #{type_bill}", font_style: :bold)
  billing =  "#{bill_address.dni_cuit} "
  billing << "\n#{bill_address.firstname} #{bill_address.lastname}"
  billing << "\n#{bill_address.address1}"
  billing << "\n#{bill_address.address2}" unless bill_address.address2.blank?
  billing << "\n#{bill_address.city}, #{bill_address.state.name}"
  billing << "\n#{bill_address.country.name}"
  billing << "\n#{bill_address.phone}"

  dataAddress = [[address_cell_billing], [billing]]
end

if (ship_address != nil)
  address_cell_shipping = pdf.make_cell(content: Spree.t(:shipping_address), font_style: :bold)
  shipping =  "#{ship_address.firstname} #{ship_address.lastname}"
  shipping << "\n#{ship_address.address1}"
  shipping << "\n#{ship_address.address2}" unless ship_address.address2.blank?
  shipping << "\n#{ship_address.city}, #{ship_address.state.name}"
  if (ship_address.country != nil)
    shipping << "\n#{ship_address.country.name}" 
  end
  shipping << "\n#{ship_address.phone}"
  if (printable.metodo_envio == "other")
    shipping << "\nTipo Envio: Otro - #{printable.metodo_envio_otros}"
  else
    metodo_envio_str=Spree.t("metodos_envio.#{printable.metodo_envio}")
    shipping << "\nTipo Envio: #{metodo_envio_str}"
  end

  if (printable.checkout_notes != "")
    shipping << "\nNotas adicionales: #{printable.checkout_notes}"
  end

  if (printable.shipments != nil && !printable.shipments.empty?)
    shipping << "\n#{Spree.t(:via, scope: :print_invoice)} #{printable.shipping_methods.join(", ")}"
  end
  
  dataShip = [[address_cell_shipping], [shipping]]
end

if (dataAddress != nil && dataShip == nil)
  pdf.table(dataAddress, position: :center, column_widths: [pdf.bounds.width / 2, pdf.bounds.width / 2])
elsif (dataAddress == nil && dataShip != nil)
  pdf.table(dataShip, position: :center, column_widths: [pdf.bounds.width / 2, pdf.bounds.width / 2])
elsif (dataAddress != nil && dataShip != nil)
  data = [[address_cell_billing, address_cell_shipping], [billing, shipping]]
  pdf.table(data, position: :center, column_widths: [pdf.bounds.width / 2, pdf.bounds.width / 2])
end
  