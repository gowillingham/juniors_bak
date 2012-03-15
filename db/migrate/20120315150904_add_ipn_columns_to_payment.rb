class AddIpnColumnsToPayment < ActiveRecord::Migration
  def self.up
    change_table :payments do |t|
      t.string :paypal_txn_type, :null => true
      t.string :paypal_payment_type, :null => true
      t.string :paypal_verify_sign, :null => true
      t.string :paypal_payer_status, :null => true
      t.string :paypal_mc_fee, :null => true
    end
  end

  def self.down
    change_table :payments do |t|
      t.remove :paypal_txn_type
      t.remove :paypal_payment_type
      t.remove :paypal_verify_sign
      t.remove :paypal_payer_status
      t.remove :paypal_mc_fee
    end
  end
end
