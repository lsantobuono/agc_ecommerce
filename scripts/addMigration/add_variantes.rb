module Spree
  require 'spreadsheet'    
  require "i18n"

  book = Spreadsheet.open('scripts/addMigration/ETIQUETAS_0.xls')
  sheet1 = book.worksheet('Hoja1')
  sheet1.each do |row| 
    productoName = row[0]
    varianteSku = row[1]
    cost_price = row[2]
    price = row[3]
    opciones = row[4]
    stock = row[5]

    producto = Product::where("unaccent(name)= '#{I18n.transliterate(productoName)}'").first

    if (producto != nil)
      old = Variant::find_by(sku: "#{producto.master.sku}-#{varianteSku}")
      if (old != nil)
        old.destroy
      end
      
      v = Variant::new()
      v.sku = "#{producto.master.sku}-#{varianteSku}"
      if (cost_price == nil || cost_price=="")
        cost_price=producto.master.cost_price
      end
      if (price == nil || price=="")
        price=producto.master.price
      end
        

      v.cost_price = cost_price
      v.price = price
      v.product = producto
      
      opts =  opciones.split(';')
      opts.each do |o|
        arrayOp = o.split(':')
        myOp = OptionType::find_by(name: arrayOp[0])
        if (myOp == nil)
          puts arrayOp[0]
          aux = OptionType::new()
          aux.presentation = arrayOp[0]
          aux.name = arrayOp[0] #Por ahora name y presentation coinciden, quiza haga falta cambiarlo
          aux.save
          myOp = aux 
        end

        myOpVal = OptionValue::find_by(name:arrayOp[1],option_type_id: myOp.id)
        if (myOpVal == nil)
          aux = OptionValue::new()
          aux.name = arrayOp[1]
          aux.presentation = arrayOp[1]#Por ahora name y presentation coinciden, quiza haga falta cambiarlo
          aux.option_type = myOp 
          aux.save
          myOpVal = aux
        end

        v.option_values << myOpVal
      end

      if (varianteSku != "E0") # Si es la etiqueta 0 no se guarda foto porque se usa la misma del producto
        img=Spree::Image.new(attachment: File.open("FOTOS/ETIQUETAS/#{varianteSku}.jpg"))
        v.images << img
      end

      if !v.save
        v.errors.each do |e|
          puts "variant errores : #{e}"
          puts "sku: #{producto.master.sku}-#{varianteSku}"
        end
      end
      
      producto.variants << v
      producto.save
      
      stock_producto = producto.master.stock_items.first
      stock_producto.backorderable = true  #El tema es asi.... si le creo una variante a un prod, no quiero que me joda
      # el stock del master, porque el master no se va a usar si hay variantes...

      if !stock_producto.save
        stock_producto.errors.each do |e|
          puts "stock_producto en variants errores : #{e}"
        end
      end

      puts "OK #{productoName}-#{varianteSku}"
      stock_items = v.stock_items.first
      stock_items.count_on_hand = stock
      stock_items.save
    else
      puts "NO se encontro el producto #{productoName}"
    end
  end
end