data = []

invoice.items.each do |item|
  precio = (item.display_price.money.fractional.to_i / 100.00 / 1.21).round(2)

  row = []

  if (item.images.first.present?)
    row += [item.images.first.attachment.url]
  else 
    row += [""]
  end

  row += [
    item.sku,
    item.name,
    item.quantity
  ]
  if (order.ml_user.nil?)
    row += [
      (Spree::Money.new(precio)).to_s, # El fractional devuelve centavos asi que lo divido x 100
      "#{item.bonification}%",
  #    (Spree::Money.new(((item.display_price.money.fractional.to_i / 100.00) - (item.bonification * (item.display_price.money.fractional.to_i / 100.00) / 100.00 ))* item.quantity / 1.21)).to_s,
       (Spree::Money.new(precio* item.quantity* ((100-item.bonification)/100.00))).to_s
    ]
  end

  data += [row]
end


column_widths = [[0,100], [100,70], [170,150], [320,50], [370,50], [420,50], [470,50]]

row_height = 55

header = [
  "",
  Spree.t(:sku),
  Spree.t(:item_description),
  Spree.t(:qty)
]

if (order.ml_user.nil?)
  header+= [
    Spree.t(:price),
    Spree.t(:bonificacion),
    Spree.t(:subtotal)
  ]
end

# Column Header Values
width = 370
if (order.ml_user.nil?)
  width = 520
end

pdf.bounding_box [0, pdf.cursor], :width => width, :height => 20 do
  header.each_with_index do |head,i|
    pdf.bounding_box [column_widths[i][0],0], :height => 20, :width => column_widths[i][1] do
      pdf.stroke_color '000000'
      pdf.stroke_bounds
      pdf.move_down 5 # a bit of padding
      pdf.text head, :size => 10, align: :center
    end
  end
end

pdf.move_down 20


size = data.count
current_page = 1
last_page = 1 + (size-1) / 7


data.each_with_index do |p,i|
  pdf.bounding_box [0, pdf.cursor], :height => row_height, :width => width do
    #pdf.stroke_bounds
    pdf.stroke do
      pdf.line pdf.bounds.top_left,    pdf.bounds.top_right
      pdf.line pdf.bounds.bottom_left, pdf.bounds.bottom_right
      pdf.line pdf.bounds.top_left,    pdf.bounds.bottom_left
      pdf.line pdf.bounds.top_right,   pdf.bounds.bottom_right
    end
    #pdf.move_down 5 # a bit of padding
    cursor = pdf.cursor # keep current cursor value for all cells in this row
    p.each_with_index do |v, j|
      pdf.bounding_box [column_widths[j][0], cursor], :height => row_height, :width => column_widths[j][1] do
        pdf.stroke do
          pdf.line pdf.bounds.top_left,    pdf.bounds.bottom_left
          pdf.line pdf.bounds.top_right,   pdf.bounds.bottom_right
        end
        if j == 0 # handle image column
          if (v.present? && v != "")
            pdf.move_down 5
            pdf.image open(v), :fit => [90,45], position: :center, position: :center
          end
        else
          pdf.text v, align: :center, valign: :center, :size => 10 unless v.blank?
        end
      end
    end
  end

  im = Rails.application.assets.find_asset("down_arrow.png")

  # create a new page every 7 rows  
  if (i > 0) && (i+1) % 7 == 0 
    if current_page != last_page
      pdf.move_down 5
      pdf.image im.filename, vposition: :down, position: :right, height: 30
    end
    pdf.start_new_page
    current_page += 1
  end

end