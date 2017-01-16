module Spree
	module Admin
		UsersController.class_eval do 
			def confirmate()
				if @user.confirm!
					flash[:success] = Spree.t('user_confirmated')
				end
				redirect_to edit_admin_user_path(@user)
			end

		 protected

      def collection
        return @collection if @collection.present?
        @collection = super

        if request.xhr? && params[:q].present?
          @collection = @collection.includes(:bill_address, :ship_address)
                            .where("spree_users.email #{LIKE} :search
                                   OR (spree_addresses.firstname #{LIKE} :search AND spree_addresses.id = spree_users.bill_address_id)
                                   OR (spree_addresses.lastname  #{LIKE} :search AND spree_addresses.id = spree_users.bill_address_id)
                                   OR (spree_addresses.firstname #{LIKE} :search AND spree_addresses.id = spree_users.ship_address_id)
                                   OR (spree_addresses.lastname  #{LIKE} :search AND spree_addresses.id = spree_users.ship_address_id)",
                                  { :search => "#{params[:q].strip}%" }) #.order("created_at desc")
                            .limit(params[:limit] || 100)
					@collection = @collection.order("created_at desc")
        else
					@search = @collection.ransack(params[:q])
					@collection = @search.result.page(params[:page]).per(Spree::Config[:admin_products_per_page])
          @collection = @collection.order("created_at desc") # Intente ordenarlo con ransack pero no pude asi que hago esto 
        end
      end

    end
	end
end
