header = [
  pdf.make_cell(content: Spree.t(:sku)),
  pdf.make_cell(content: Spree.t(:item_description)),
  pdf.make_cell(content: Spree.t(:qty)),
  pdf.make_cell(content: Spree.t(:price)),
  pdf.make_cell(content: Spree.t(:bonificacion)),
  pdf.make_cell(content: Spree.t(:subtotal))
]
data = [header]

invoice.items.each do |item|
  row = [
    item.sku,
    item.name,
    item.quantity,
    (Spree::Money.new(item.display_price.money.fractional.to_i / 100 / 1.21)).to_s, # El fractional devuelve centavos asi que lo divido x 100
    "0",
    (Spree::Money.new(item.display_total.money.fractional.to_i / 100 / 1.21)).to_s,
  ]
  data += [row]
end

column_widths = [0.13, 0.37, 0.12, 0.12, 0.12, 0.14].map { |w| w * pdf.bounds.width }

pdf.table(data, header: true, position: :center, column_widths: column_widths) do
  row(0).style align: :center, font_style: :bold
  column(0..2).style align: :left
  column(3..6).style align: :right
end
