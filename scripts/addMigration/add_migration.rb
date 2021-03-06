module Spree
  require 'spreadsheet'    


  book = Spreadsheet.open('scripts/addMigration/productos.xls')
  sheet1 = book.worksheet('NUEVOS') 
  sheet1.each do |row| 
    if (row[0] != nil && row[0] != "")
      sku = row[0]
      name = row[1]
      descripcion = row[2]
      
      precio = 1 # Este valor es solo para la carga inicial... despues se actualiza con el proceso normal del excel

      slug = row[4] #Link al producto. minusculas, dben ser unicos
      category = row[5]
      cost_price = row[7]
      
      stock = 100 # default 100
      if (row[8] != nil && row[8] != "")
        stock = row[8]
      end

      properties = {}

      if (row[6] != nil && row[6] != "")
        pro =  row[6].split(';')
        pro.each do |p|
          aux = p.split(':')
          properties[aux[0]] = aux[1]
        end
      end

      old = Product::find_by(name: name)
      if (old != nil) # aca hay un bug con los slugs... flagea el producto pero no borra el slut y eso hace que falle.
        old.destroy!
      end


      p = Product.new()
      # Valores normales
      p.master.sku=sku # el ID producto corresponde al sku del variant master.
      p.name=name

      puts p.name

      p.description=descripcion
      p.price = precio
      p.cost_price = cost_price 
      p.available_on = DateTime.now.to_date 
      # Valores hardcodeados (No se usan o los dejo asi por default)
      p.shipping_category_id=1
      p.tax_category_id = 1

      # Valores que se calculan..
      p.taxons << Taxon::find_by(name: category)
      properties.each do |prop|
        pr = Property::find_by(name: prop[0])
        if (pr == nil)
          aux = Property::new();
          aux.name = prop[0]
          aux.presentation = prop[0]
          aux.save!
        pr = aux
        end
        pp = ProductProperty::new()
        pp.property = pr
        pp.value = prop[1]
        p.product_properties << pp
      end
      
      if !p.save!
      p.errors.each do |e|
          puts "productos- errores : #{e}"
        end
      end 


      stock_items = p.stock_items.first
      stock_items.count_on_hand = stock
      stock_items.save!
    end
  end

  book = Spreadsheet.open('scripts/addMigration/variantes.xls')
  sheet1 = book.worksheet('Hoja1') 
  sheet1.each do |row| 
    productoName = row[0]
    varianteSku = row[1]
    cost_price = row[2]
    price = row[3]
    opciones = row[4]
    stock = row[5]

    producto = Product::find_by(name: productoName)
    if (producto != nil)

      old = Variant::find_by(sku: varianteSku)
    if (old != nil)
        old.destroy!
      end
    v = Variant::new()
    v.sku = varianteSku
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
          aux.save!
          myOp = aux 
        end

        myOpVal = OptionValue::find_by(name:arrayOp[1],option_type_id: myOp.id)
        if (myOpVal == nil)
          aux = OptionValue::new()
          aux.name = arrayOp[1]
          aux.presentation = arrayOp[1]#Por ahora name y presentation coinciden, quiza haga falta cambiarlo
          aux.option_type = myOp 
          aux.save!
          myOpVal = aux
        end

        v.option_values << myOpVal
    end

      producto.variants << v

      stock_producto = producto.master.stock_items.first
      stock_producto.backorderable = true  #El tema es asi.... si le creo una variante a un prod, no quiero que me joda
      # el stock del master, porque el master no se va a usar si hay variantes...

      if !stock_producto.save!
      stock_producto.errors.each do |e|
        puts "stock_producto en variants errores : #{e}"
        end
    end

      if !v.save!
      v.errors.each do |e|
        puts "variant errores : #{e}"
        end
    end

      stock_items = v.stock_items.first
      stock_items.count_on_hand = stock
      stock_items.save!
    end

  end


  book = Spreadsheet.open('scripts/addMigration/imagenes.xls')
  sheet1 = book.worksheet('NUEVAS') 
  sheet1.each do |row| 
    if (row[0] == 'P')
      p = Product.find_by(name: row[1])
      if (p != nil)
        if (File.exists? row[2])
          p.images << Spree::Image.new(attachment: File.open(row[2]))
          puts row[2]
        else 
          puts "No existe file #{row[2]}"
        end
      else 
        puts "No existe prod #{row[1]}"
      end
    elsif (row[0] == 'V')
      v = Variant.find_by(sku: row[1])
      if (v != nil)
          if (File.exists? row[2])
            v.images << Spree::Image.new(attachment: File.open(row[2]))
          end
      end
    end
  end

  Price.all.each do |p|
    p.currency="ars"
    p.save!
  end
end