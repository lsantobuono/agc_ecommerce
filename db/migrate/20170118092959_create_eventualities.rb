class CreateEventualities < ActiveRecord::Migration
  def change
    create_table :eventualities do |t|
      t.string :message, null: false
      t.integer :type_eventuality, null: false
      t.timestamps null: false
    end

    change_table :spree_stores do |t|
      t.integer :eventuality_id
    end

  end
end
