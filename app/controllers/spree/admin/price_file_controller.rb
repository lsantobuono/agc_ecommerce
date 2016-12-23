module Spree::Admin
  class PriceFileController < ResourceController

    def model_class
      PriceFile
    end

    def index
    end

    def create
      @listaCambios = {}
      
      uploaded = params[:attachment]
      file = File.open("/tmp/csvprice.xls", 'wb')
      file.write(uploaded.read)
      
      book = Spreadsheet.open(file.path)
      sheet1 = book.worksheet 1
      sheet1.each do |row| 
        if (row[0] != "" && row[0] != nil)
          var = Spree::Variant.find_by(sku: row[0])
          if (var != nil &&  ((var.price - row[4].value).abs > 0.003)) # Esta porqueria es por como se guardan los float en ruby.. es basicamente un !=
            arrPrice=[]
            arrPrice[0] = var.price
            arrPrice[1] = row[4].value
            @listaCambios[row[0]] = arrPrice
          end
        end
      end

      render "spree/admin/price_file/index"
    end

    def confirm
      @preciosActualizados = {}

      file = File.open("/tmp/csvprice.xls", 'rb')
      book = Spreadsheet.open(file.path)
      sheet1 = book.worksheet 1
      sheet1.each do |row| 
        if (row[0] != "" && row[0] != nil)
          var = Spree::Variant.find_by(sku: row[0])
          if (var != nil &&  ((var.price - row[4].value).abs > 0.003)) # Esta porqueria es por como se guardan los float en ruby.. es basicamente un !=
            auxPrice = var.price
            var.price = row[4].value
            if var.save!
              arrPrice=[]
              arrPrice[0] = auxPrice
              arrPrice[1] = var.price
              @preciosActualizados[row[0]] = arrPrice
            end
          end
        end     
      end
    render "spree/admin/price_file/index"
    end 
  
  end
end
