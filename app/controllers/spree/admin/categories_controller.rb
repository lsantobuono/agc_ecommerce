module Spree::Admin
  class CategoriesController < ResourceController
    before_action :set_category, only: [:show, :edit, :update, :destroy]
    before_action :categories_select, only: [:new, :edit, :create, :update]

    include SortableTreeController::Sort
    sortable_tree 'Category', parent_method: 'parent', sorting_attribute: 'pos'
   
    def model_class
      Category
    end

    def index
      @items = Category.all.arrange(order: :pos)
    end

    def show
      #@hide_category_filter = true
      #smart_listing_create :products, scope_busqueda_productos, partial: 'products/listing', default_sort: { 'products.id' => :desc }
    end

    def new
      @category = Category.new params.permit(:parent_id)
    end

    def edit
    end

 #   def create
 #     @category = Category.new(category_params)
  #    save_and_respond(@category, 'Categoría creada correctamente.')
 #   end


  #  def render_json
  #    return render json: [] unless params[:parent_id].present?
  #    render json: Category.by_context(params[:context]).children_of(params[:parent_id])
  #  end

    def subcategories_products
      if params[:maker_id].present?
        maker_selected
        return
      end

      category_selected if params[:category_id].present?
      subcategory_selected if params[:subcategory_id].present?
    end

    def scope_busqueda_productos
  #    products_scope = Product.includes(:category, :maker).where(context: Product.contexts[params[:context]]).by_category(@category.id.to_s)
  #    products_scope = filtrar(products_scope, 'name', 'filter_name')
  #    products_scope = filtrar(products_scope, 'code', 'filter_code')
  #    products_scope.by_maker(params[:filter_maker])
    end

    def filtrar(scope, campo, key)
  #    param = params[key.to_s]
  #    scope = scope.where("unaccent(products.#{campo}) ILIKE ?", "%#{I18n.transliterate(param)}%") if param
  #    scope
    end

    private

    def category_selected
      @subcategories = Category.children_of(params[:category_id]).with_combos
      return if @subcategories.present?
      @combos = Combo.by_category(params[:category_id])
    end

    def subcategory_selected
    end

    def maker_selected
    end

    def ancestry_options(items, &block)
  #    return ancestry_options(items) { |i| "#{'-' * i.depth} #{i.name}" } unless block_given?

  #    result = []
  #    items.map do |item, sub_items|
  #      result << [yield(item), item.id]
        # this is a recursive call:
  #      result += ancestry_options(sub_items, &block)
  #    end
  #    result
    end

    def set_category
      @category = Category.find(params[:id])
    end

    def categories_select
   #   @categories = ancestry_options(Category.roots.without_combos
   #                                          .arrange(order: 'name')) { |i| "#{'-' * i.depth} #{i.name}" }
      @categories = Category.without_combos - Array(@category)
    end

    def category_params
      params.require(:category).permit(:name, :parent_id)
    end
  end
end