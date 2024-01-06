# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_01_05_161634) do

  create_table "agents", force: :cascade do |t|
    t.string "city"
    t.string "state"
    t.string "address_home"
    t.string "zip_code"
    t.string "licence"
    t.string "split"
    t.string "phone"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_agents_on_user_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "name"
    t.string "type_of_file"
    t.string "path"
    t.integer "library_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["library_id"], name: "index_documents_on_library_id"
  end

  create_table "libraries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.date "current_date"
    t.string "agent1_name"
    t.string "agent2_name"
    t.string "agent3_name"
    t.string "type_of_transaction"
    t.string "property_address"
    t.string "seller_lessor"
    t.string "buyer_lessee"
    t.string "agent_client"
    t.string "closing_date"
    t.string "title_escrow_company"
    t.string "sale_purchase"
    t.string "bank_deposit"
    t.string "transaction_fee_amount"
    t.string "commission_percentage"
    t.string "agent1_commission_percentage"
    t.string "agent1_commission_amount"
    t.string "agent2_commission_percentage"
    t.string "agent2_commission_amount"
    t.string "referral_to"
    t.string "referral_amount"
    t.string "office_commission_percentage"
    t.string "office_commission_amount"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "last_name"
    t.integer "role"
    t.boolean "active", default: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
