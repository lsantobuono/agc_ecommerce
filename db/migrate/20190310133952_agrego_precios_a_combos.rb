class AgregoPreciosACombos < ActiveRecord::Migration
  def change
    codes = [ "TEJ-4M-10D6-20PL","TEJ-2M-5D6","TEJ-2M-5D6-20PL","TEJ-50M","TEJ-50MCH","TEJ-10M-20D6","MU-KCSP",
              "MU-KPR","MU_KP","USB1-1C-9B","USB1-1C-9B-CC","USB1-1C-9BL","USB1-1C-9BL-CC","USBP-1C-13B",
              "USBP-1C-13B-CC","USBP-1C-13BL","USBP-1C-13BL-CC","USB2-2C-21B","USB2-2C-18B","USB2-2C-18B-CC",
              "USB2-2C-18BL","USB2-2C-18BL-CC", "USB2-2C-20BL-CC" ]

    prices = [ [474, 502],[152 ,161],[322, 341],[2300 , 2438],[1950 , 2067],[700, 742],[2000 ,2120],[584,619],
                [372, 394],[1676,  1776],[1876  ,1988],[1910 , 2024],[2110,  2236],[2077 , 2201],[2337,  2477],
                [2415 , 2559],[2675,  2835],[3376 , 3578],[3202 , 3394],[3662 , 3881],[3670 , 3890],[4130,  4377], 
                [4298, 4555]]


    codes.each_with_index do |code, index|
      c = Combo.where(code: code).first
      if c.present?
        c.price_cash = prices[index][0]
        c.price_mercado_pago = prices[index][1]
        c.save
      end
    end
  end
end
