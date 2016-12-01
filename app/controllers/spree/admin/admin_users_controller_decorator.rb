module Spree
	module Admin
		UsersController.class_eval do 
			def confirmate()
				if @user.confirm!
					flash[:success] = Spree.t('user_confirmated')
				end
				redirect_to edit_admin_user_path(@user)
			end
		end
	end
end
