# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120326191458) do

  create_table "payments", :force => true do |t|
    t.integer  "registration_id"
    t.string   "paypal_txn_id"
    t.boolean  "paypal_sandbox"
    t.string   "paypal_payment_status"
    t.string   "paypal_pending_status_reason"
    t.integer  "amount"
    t.boolean  "online",                       :default => false
    t.boolean  "scholarship",                  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "paypal_txn_type"
    t.string   "paypal_payment_type"
    t.string   "paypal_verify_sign"
    t.string   "paypal_payer_status"
    t.string   "paypal_mc_fee"
  end

  create_table "products", :force => true do |t|
    t.string   "name",                          :null => false
    t.string   "description"
    t.integer  "price"
    t.boolean  "enabled",     :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "session"
    t.string   "category"
  end

  create_table "registrations", :force => true do |t|
    t.string   "first_name",                            :null => false
    t.string   "last_name",                             :null => false
    t.string   "parent_first_name",                     :null => false
    t.string   "parent_last_name",                      :null => false
    t.integer  "grade",                                 :null => false
    t.string   "school",                                :null => false
    t.string   "email",                                 :null => false
    t.string   "address",                               :null => false
    t.string   "city",                                  :null => false
    t.string   "state",                                 :null => false
    t.string   "zip",                                   :null => false
    t.string   "phone",                                 :null => false
    t.boolean  "parent_helper",      :default => false
    t.boolean  "has_release",        :default => false
    t.string   "tshirt_size",                           :null => false
    t.string   "parent_tshirt_size"
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_me_token"], :name => "index_users_on_remember_me_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"

end
