# TOTALS
totals = []
sumTotal = 0

if order.combo_order
  sumTotal = invoice.display_item_total.money.fractional.to_i / 100.00
else
  invoice.items.each do |item|
    precio_redondeado = (item.display_price.money.fractional.to_i / 100.00).round(2)
    sumTotal +=  precio_redondeado* item.quantity* ((100-item.bonification)/100.00)
  end
end

sumTotal = sumTotal.round 2

totals << [pdf.make_cell(content: Spree.t(:order_total)), Spree::Money.new(sumTotal).to_s]

# Payments
total_payments = 0.0
invoice.payments.each do |payment|
  totals << [
    pdf.make_cell(
      content: Spree.t(:payment_via,
      gateway: (payment.source_type || Spree.t(:unprocessed, scope: :print_invoice)),
      number: payment.number,
      date: I18n.l(payment.updated_at.to_date, format: :long),
      scope: :print_invoice)
    ),
    payment.display_amount.to_s
  ]
  total_payments += payment.amount
end

totals_table_width = [0.875, 0.125].map { |w| w * pdf.bounds.width }
pdf.table(totals, column_widths: totals_table_width) do
  row(0..6).style align: :right
  column(0).style borders: [], font_style: :bold
end
