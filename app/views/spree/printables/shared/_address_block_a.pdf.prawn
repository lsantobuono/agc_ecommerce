bill_address = printable.bill_address
ship_address = printable.ship_address

pdf.move_down 2

dataAddress = nil
dataShip = nil

if (bill_address != nil)
  address_cell_billing  = pdf.make_cell(content: "#{Spree.t(:billing_data)} Factura A", font_style: :bold)
  billing =  "#{bill_address.dni_cuit} "
  billing << "\n#{bill_address.firstname} #{bill_address.lastname}"
  billing << "\n#{bill_address.address1}"
  billing << "\n#{bill_address.address2}" unless bill_address.address2.blank?
  billing << "\n#{bill_address.city}, #{bill_address.state_text} #{bill_address.zipcode}"
  billing << "\n#{bill_address.country.name}"
  billing << "\n#{bill_address.phone}"

  dataAddress = [[address_cell_billing], [billing]]
end

if (ship_address != nil)
  address_cell_shipping = pdf.make_cell(content: Spree.t(:shipping_address), font_style: :bold)
  shipping =  "#{ship_address.firstname} #{ship_address.lastname}"
  shipping << "\n#{ship_address.address1}"
  shipping << "\n#{ship_address.address2}" unless ship_address.address2.blank?
  shipping << "\n#{ship_address.city}, #{ship_address.state_text} #{ship_address.zipcode}"
  shipping << "\n#{ship_address.country.name}"
  shipping << "\n#{ship_address.phone}"
  shipping << "\n\n#{Spree.t(:via, scope: :print_invoice)} #{printable.shipping_methods.join(", ")}"
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
  