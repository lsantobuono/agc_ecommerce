# Configuracion del print invoice...

Spree::PrintInvoice::Config.set(logo_path: "logo.png")
Spree::PrintInvoice::Config.set(page_layout: :portrait,page_size: 'A4')
Spree::PrintInvoice::Config.set(store_pdf: true) # Default: false
Spree::PrintInvoice::Config.set(storage_path: 'tmp/order_prints') # Default: tmp/order_prints
Spree::PrintInvoice::Config.set(use_footer: true)