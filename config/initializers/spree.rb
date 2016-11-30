# Configure Spree Preferences
#
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# Note: If a preference is set here it will be stored within the cache & database upon initialization.
#       Just removing an entry from this initializer will not make the preference value go away.
#       Instead you must either set a new value or remove entry, clear cache, and remove database entry.
#
# In order to initialize a setting do:
# config.setting_name = 'new value'
require 'spree/core/product_filters'

Spree.config do |config|
  # Example:
  # Uncomment to stop tracking inventory levels in the application
  # config.track_inventory_levels = false
	country = Spree::Country.find_by_name('Argentina')
	config.default_country_id = country.id if country.present?	
	config.currency = "ars"
	config.allow_guest_checkout = false
	config.max_level_in_taxons_menu = 99
	#config.site_name = "AGC Repuestos para video juegos"
end

Spree.user_class = "Spree::User"

Spree::Auth::Config[:confirmable] = true

Spree::PermittedAttributes.user_attributes.push :phone_number, :first_name, :last_name, :enterprise, :address
