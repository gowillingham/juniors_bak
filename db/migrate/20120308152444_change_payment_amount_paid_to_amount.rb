class ChangePaymentAmountPaidToAmount < ActiveRecord::Migration
  def self.up
    rename_column :payments, :amount_paid, :amount
  end

  def self.down
    rename_column :payments, :amount, :amount_paid
  end
end
