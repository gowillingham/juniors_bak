class SetProductsPriceToNullable < ActiveRecord::Migration
  def self.up
    change_column :products, :price, :integer, :null => true, :default => nil
  end

  def self.down
    change_column :products, :price, :integer, :null => false, :default => 0
  end
end
