class AddSessionToProduct < ActiveRecord::Migration
  def self.up
    change_table :products do |t|
      t.string :session, :null => true
    end
  end

  def self.down
    change_table :products do |t|
      t.remove :session
    end
  end
end
