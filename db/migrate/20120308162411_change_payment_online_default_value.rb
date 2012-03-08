class ChangePaymentOnlineDefaultValue < ActiveRecord::Migration
  def self.up
    change_column :payments, :online, :boolean, :default => false
  end

  def self.down
    change_column :payments, :online, :boolean, :default => false
  end
end
