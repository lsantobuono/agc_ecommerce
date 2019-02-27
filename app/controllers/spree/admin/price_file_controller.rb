module Spree::Admin
  class PriceFileController < ResourceController

    def model_class
      PriceFile
    end

    def index
    end

    def is_number? string
      true if Float(string) rescue false
    end

    def create
      @listaCambios = {}
      @listaCambiosCombos = {}
      
      uploaded = params[:attachment]
      file = File.open("/tmp/csvprice.xls", 'wb')
      file.write(uploaded.read)
      
      book = Spreadsheet.open(file.path)
      sheet1 = book.worksheet 'ÍNDICE PARA PÁGINA WEB'
      sheet1.each do |row| 
        if (row[0] != nil &&  row[0] != "" &&  row[4] != nil && row[4].value != nil && row[4].value != "" && (is_number? row[4].value))
          var = Spree::Variant.find_by(sku: row[0])
          if (var != nil &&  ((var.price - row[4].value).abs > 0.0045)) # Esta porqueria es por como se guardan los float en ruby.. es basicamente un !=
            arrPrice=[]
            arrPrice[0] = var.price
            arrPrice[1] = row[4].value
            @listaCambios[row[0]] = arrPrice
          end
        end
      end
      
      sheet_combos = book.worksheet 'COMBOS'
      sheet_combos.each do |row|
        if (row[0].present? && (is_number? row[1]) && (is_number? row[2]) )
          combo = Combo.find_by(code: row[0])
          if combo.present?
            if (
              (combo.price_cash.nil? || combo.price_mercado_pago.nil?) ||
              (((combo.price_cash - row[1]).abs > 0.0045) || 
              ((combo.price_mercado_pago - row[2]).abs > 0.0045)))
              arrPrice=[]
              arrPrice[0] = combo.price_cash
              arrPrice[1] = row[1]
              arrPrice[2] = combo.price_mercado_pago
              arrPrice[3] = row[2]

              @listaCambiosCombos[row[0]] = arrPrice
            end
          end
        end
      end
      render "spree/admin/price_file/index"
    end

    def confirm
      @preciosActualizados = {}
      @preciosActualizadosCombos = {}

      file = File.open("/tmp/csvprice.xls", 'rb')
      book = Spreadsheet.open(file.path)
      sheet1 = book.worksheet 'ÍNDICE PARA PÁGINA WEB'
      sheet1.each do |row| 
        if (row[0] != nil &&  row[0] != "" &&  row[4] != nil && row[4].value != nil && row[4].value != "" && (is_number? row[4].value))
          var = Spree::Variant.find_by(sku: row[0])
          if (var != nil &&  ((var.price - row[4].value).abs > 0.0045)) # Esta porqueria es por como se guardan los float en ruby.. es basicamente un !=
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
      sheet_combos = book.worksheet 'COMBOS'
      sheet_combos.each do |row|
        if (row[0].present? && (is_number? row[1]) && (is_number? row[2]) )
          combo = Combo.find_by(code: row[0])
          if combo.present?
            if (
              (combo.price_cash.nil? || combo.price_mercado_pago.nil?) ||
              (((combo.price_cash - row[1]).abs > 0.0045) || 
              ((combo.price_mercado_pago - row[2]).abs > 0.0045)))
              auxPriceCash = combo.price_cash
              auxPriceMercadoPago = combo.price_mercado_pago
              combo.price_cash = row[1]
              combo.price_mercado_pago = row[2]
              if combo.save!
                arrPrice=[]
                arrPrice[0] = auxPriceCash
                arrPrice[1] = row[1]
                arrPrice[2] = auxPriceMercadoPago
                arrPrice[3] = row[2]
                @preciosActualizadosCombos[row[0]] = arrPrice
              end
            end
          end
        end
      end
      render "spree/admin/price_file/index"
    end 
  end
end
