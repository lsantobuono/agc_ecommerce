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
  if ActiveRecord::Base.connection.table_exists? 'spree_countries'
    country = Spree::Country.find_by_name('Argentina')
    config.default_country_id = country.id if country.present?
  end
	config.currency = "ars"
	config.allow_guest_checkout = true
	config.max_level_in_taxons_menu = 10

  #Busqueda custom para skus, esta en lib/spree
  config.searcher_class= Spree::MySearch

	#config.site_name = "AGC Repuestos para video juegos"
end

Spree.user_class = "Spree::User"

Spree::Auth::Config[:confirmable] = true

Spree::PermittedAttributes.product_attributes << :security_stock
Spree::PermittedAttributes.variant_attributes << :security_stock

Spree::PermittedAttributes.checkout_attributes.push :ml_user, :ml_purchase_id, :tipo_factura, :metodo_envio, :metodo_envio_otros, :checkout_notes
Spree::PermittedAttributes.address_attributes.push :dni_cuit

Spree::PermittedAttributes.user_attributes.push :phone_number, :first_name, :last_name, :enterprise, :address

Spree::PermittedAttributes.store_attributes.push :eventuality_id, :help_content

Spree::PermittedAttributes.line_item_attributes.push :bonification
Spree::PermittedAttributes.taxon_attributes.push({ :applied_complements_attributes => [:id, :complement_id, :quantity, :_destroy] })

Rails.application.config.to_prepare do
  Spree.user_class.whitelisted_ransackable_attributes = ['first_name','last_name']
end


# if Rails.env.production?
#  ENV['S3_BUCKET_NAME']="agcbucket90"
  attachment_config = {
    s3_credentials: {
      access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      bucket:            ENV['S3_BUCKET_NAME']
    },

    storage:        :s3,
    s3_headers:     { "Cache-Control" => "max-age=31557600" },
    s3_protocol:    "https",
    bucket:         ENV['S3_BUCKET_NAME'],
    url:            ':s3_domain_url',

    styles: {
        mini:     "48x48>",
        small:    "100x100>",
        product:  "240x240>",
        large:    "600x600>"
    },

    path:           "/:class/:id/:style/:basename.:extension",
    default_url:    "/:class/:id/:style/:basename.:extension",
    default_style:  "product"
  }

  attachment_config.each do |key, value|
    Spree::Image.attachment_definitions[:attachment][key.to_sym] = value
  end
# end



