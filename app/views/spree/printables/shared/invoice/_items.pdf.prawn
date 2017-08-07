header = [
  pdf.make_cell(content: Spree.t(:sku)),
  pdf.make_cell(content: Spree.t(:item_description)),
  pdf.make_cell(content: Spree.t(:qty))
]

if (order.ml_user.nil?)
  header+= [
    pdf.make_cell(content: Spree.t(:price)),
    pdf.make_cell(content: Spree.t(:bonificacion)),
    pdf.make_cell(content: Spree.t(:subtotal))
  ]
end
data = [header]

invoice.items.each do |item|
  row = [
    item.sku,
    item.name,
    item.quantity
  ]
  if (order.ml_user.nil?)
    row += [
      (item.display_price.to_s,
      (item.display_total.to_s
  ]
  data += [row]
end

column_widths = [0.13, 0.33, 0.2, 0.2, 0.14].map { |w| w * pdf.bounds.width }

pdf.table(data, header: true, position: :center, column_widths: column_widths) do
  row(0).style align: :center, font_style: :bold
  column(0..2).style align: :left
  column(3..5).style align: :right
end
