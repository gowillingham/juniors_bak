class CreateRegistrations < ActiveRecord::Migration
  def self.up
    create_table :registrations do |t|
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.string :parent_first_name, :null => false
      t.string :parent_last_name, :null => false
      t.integer :grade, :null => false
      t.string :school, :null => false
      t.string :email, :null => false
      t.string :address, :null => false
      t.string :city, :null => false
      t.string :state, :null => false
      t.string :zip, :null => false
      t.string :phone, :null => false
      t.boolean :parent_helper, :default => false
      t.boolean :has_release, :default => false
      t.string :tshirt_size, :null => false
      t.string :parent_tshirt_size, :null => true
      t.string :note, :null => true
      t.integer :session, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :registrations
  end
end
