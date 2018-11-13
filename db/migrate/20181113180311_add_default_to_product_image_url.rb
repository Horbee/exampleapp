class AddDefaultToProductImageUrl < ActiveRecord::Migration[5.2]
  def change
    remove_column :products, :image_url, :string
    remove_foreign_key :products, :orders
  end
end
