module Spree::Admin
  class EventualitiesController < Spree::Admin::BaseController

    def index
      @eventuality = Eventuality.new
    end

    def create
      @eventuality = Eventuality.new(eventuality_params)
      if @eventuality.save
          flash[:success] = "Eventualidad agregada"
      else
          flash[:error] = "Error en la carga"
      end
      redirect_to admin_eventualities_path
    end

    def destroy
      @eventuality = Eventuality.find(params[:id])
      if @eventuality.destroy
          flash[:success] = "Mensaje borrado"
      else
          flash[:error] = "Error en el borrado"
      end
      redirect_to admin_eventualities_path
    end

    private
      def eventuality_params
        params.require(:eventuality).permit( :message, :type_eventuality)
      end

  end
end
