class AddMailPresupuestoHeaderToStores < ActiveRecord::Migration
  def change
    add_column :spree_stores, :presupuesto_email_header, :string
    add_column :spree_stores, :presupuesto_email_footer, :string
  end
end
