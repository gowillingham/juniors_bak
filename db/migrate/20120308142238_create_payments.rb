class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :registration_id
      t.string :paypal_txn_id
      t.boolean :paypal_sandbox
      t.string :paypal_payment_status
      t.string :paypal_pending_status_reason
      t.integer :amount_paid
      t.boolean :online, :default => true
      t.boolean :scholarship, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
