class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :name, :null => false
      t.string :description, :null => true
      t.integer :price, :null => false, :default => 0
      t.boolean :enabled, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
