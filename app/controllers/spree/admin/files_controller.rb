module Spree
  module Admin
    class FilesController < ResourceController
      before_action :load_edit_data, except: :index
      before_action :load_index_data, only: :index

      create.before :set_viewable
      update.before :set_viewable

      private

      def location_after_destroy
        admin_product_files_url(@product)
      end

      def location_after_save
        admin_product_files_url(@product)
      end

      def load_index_data
        @product = Product.friendly.includes(*variant_index_includes).find(params[:product_id])
      end

      def load_edit_data
        @product = Product.friendly.includes(*variant_edit_includes).find(params[:product_id])
        @variants = @product.variants.map do |variant|
          [variant.sku_and_options_text, variant.id]
        end
        @variants.insert(0, [Spree.t(:all), @product.master.id])
      end

      def set_viewable
        @file.viewable_type = 'Spree::Variant'
        @file.viewable_id = params[:file][:viewable_id]
      end

      def variant_index_includes
        [
          variant_files: [viewable: { option_values: :option_type }]
        ]
      end

      def variant_edit_includes
        [
          variants_including_master: { option_values: :option_type, files: :viewable }
        ]
      end
    end
  end
end
