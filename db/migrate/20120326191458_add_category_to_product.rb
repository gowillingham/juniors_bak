class AddCategoryToProduct < ActiveRecord::Migration
  def self.up
  	change_table :products do |t|
  		t.string :category
  	end
  end

  def self.down
  	change_table :products do |t|
  		t.remove :category
  	end
  end
end
