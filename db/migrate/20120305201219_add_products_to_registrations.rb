class AddProductsToRegistrations < ActiveRecord::Migration
  def self.up
    change_table :registrations do |t| 
      t.integer :product_id
    end
  end

  def self.down
    change_table :registrations do |t|
      t.remove :product_id
    end
  end
end
