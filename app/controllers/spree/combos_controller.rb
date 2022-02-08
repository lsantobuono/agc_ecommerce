module Spree
  class CombosController < Spree::StoreController
    include ParserComboCompuesto

    def index
      @combos=Combo.all
      if (Spree::Store.first.eventuality_id !=nil && Spree::Store.first.eventuality_id != 0 )
        e = Eventuality.find(Spree::Store.first.eventuality_id)
        if (e != nil)
          type = (e.type_eventuality == 0) ? :danger : :info 
          flash.now[type]= e.message
        end
      end
    end

    def mercado_libre
    end

    def mercado_libre_combo
      correct_string, @combos_y_cantidades = parsear_combo_compuestos(params[:combo_id])
      if (!correct_string)
        flash[:error] = @combos_y_cantidades
        redirect_back_or_default(spree.root_path)
        return
      end
    end

    def seleccionar_cantidad
      @combo = Combo.find(params[:combo_id])
    end

    def ordenar_combo
      combo = Combo.find(params[:combo_id])
      cantidad = params[:cantidad].present? ? params[:cantidad].to_i : 1
      @combos_y_cantidades = [{ random_id: rand(1000000000000), combo: combo, quantity: cantidad}]
      @combo_order = true
      render :ordenar_combo_compuesto
    end

    def ordenar_combo_compuesto
      correct_string, @combos_y_cantidades = parsear_combo_compuestos(params[:combo_string])
    end
  end
end
