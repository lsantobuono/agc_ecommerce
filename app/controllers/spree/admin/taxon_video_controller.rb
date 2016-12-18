module Spree::Admin
  class TaxonVideoController < ResourceController

    
    def model_class
      Spree::Video
    end

    def index
      @video = Spree::Video.new
    end

    def create

      @taxon = Spree::Taxon.find( params[:video][:taxon])
      @video = @taxon.videos.build(video_params)
      if @video.save
          flash[:success] = "Video agregada"
      else
          flash[:error] = "Error en la carga"
      end
      redirect_to admin_taxon_video_path
    end

    def destroy
      @video = Spree::Video.find(params[:id])
      if @video.destroy
          flash[:success] = "Video borrado"
      else
          flash[:error] = "Error en el borrado"
      end
      redirect_to admin_taxon_video_path
    end

    private
      def video_params
      params.require(:video).permit( :video, :descripcion)
    end



  end
end
