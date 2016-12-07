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
      sheet1 = book.worksheet('Hoja1') 
      sheet1.each do |row| 
        if (row[2] != "" && row[2] != nil)
          var = Spree::Variant.find_by(sku: row[2])
          if (var != nil && var.price != row[8])
            arrPrice=[]
            arrPrice[0] = var.price
            arrPrice[1] = row[8]
            @listaCambios[row[2]] = arrPrice
          end
        end
      end

      render "spree/admin/price_file/index"
    end

    def confirm
      @preciosActualizados = {}

      file = File.open("/tmp/csvprice.xls", 'rb')
      book = Spreadsheet.open(file.path)
      sheet1 = book.worksheet('Hoja1') 
      sheet1.each do |row| 
        if (row[2] != "" && row[2] != nil)
          var = Spree::Variant.find_by(sku: row[2])
          if (var != nil)
            auxPrice = var.price
            var.price = row[8]
            if var.save!
              arrPrice=[]
              arrPrice[0] = auxPrice
              arrPrice[1] = var.price
              @preciosActualizados[row[2]] = arrPrice
            end
          end
        end     
      end
    render "spree/admin/price_file/index"
    end 
  
  end
end
