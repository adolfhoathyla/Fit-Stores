# encoding: UTF-8
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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151125123214) do

  create_table "addresses", force: :cascade do |t|
    t.string   "country",      limit: 255
    t.string   "state",        limit: 255
    t.string   "city",         limit: 255
    t.string   "district",     limit: 255
    t.string   "street",       limit: 255
    t.string   "number",       limit: 255
    t.string   "cep",          limit: 255
    t.string   "full_address", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "client_id",    limit: 4
    t.string   "complement",   limit: 255
    t.integer  "store_id",     limit: 4
    t.float    "latitude",     limit: 24
    t.float    "longitude",    limit: 24
  end

  add_index "addresses", ["client_id"], name: "index_addresses_on_client_id", using: :btree
  add_index "addresses", ["store_id"], name: "index_addresses_on_store_id", using: :btree

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "clients", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "birth_date"
    t.string   "name",                   limit: 255
    t.string   "telephone",              limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "auth_token",             limit: 255, default: ""
    t.string   "photo_file_name",        limit: 255
    t.string   "photo_content_type",     limit: 255
    t.integer  "photo_file_size",        limit: 4
    t.datetime "photo_updated_at"
  end

  add_index "clients", ["auth_token"], name: "index_clients_on_auth_token", unique: true, using: :btree
  add_index "clients", ["email"], name: "index_clients_on_email", unique: true, using: :btree
  add_index "clients", ["reset_password_token"], name: "index_clients_on_reset_password_token", unique: true, using: :btree

  create_table "form_of_payment_of_stores", force: :cascade do |t|
    t.integer  "form_of_payment_id", limit: 4
    t.integer  "store_id",           limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "form_of_payment_of_stores", ["form_of_payment_id"], name: "index_form_of_payment_of_stores_on_form_of_payment_id", using: :btree
  add_index "form_of_payment_of_stores", ["store_id"], name: "index_form_of_payment_of_stores_on_store_id", using: :btree

  create_table "form_of_payments", force: :cascade do |t|
    t.string   "title",      limit: 255, default: "", null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "on_sale_percentages", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.float    "percentage", limit: 24
    t.datetime "date_limit"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "product_suggestions", force: :cascade do |t|
    t.string   "name",               limit: 255, null: false
    t.string   "brand",              limit: 255, null: false
    t.string   "status",             limit: 255, null: false
    t.string   "photo_file_name",    limit: 255
    t.string   "photo_content_type", limit: 255
    t.integer  "photo_file_size",    limit: 4
    t.datetime "photo_updated_at"
    t.integer  "store_id",           limit: 4
  end

  add_index "product_suggestions", ["store_id"], name: "index_product_suggestions_on_store_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "type_of_suplement",  limit: 255,   default: "", null: false
    t.text     "desc",               limit: 65535
    t.string   "benefits",           limit: 255,   default: "", null: false
    t.string   "contraindication",   limit: 255,   default: "", null: false
    t.string   "name",               limit: 255,   default: "", null: false
    t.string   "brand",              limit: 255,   default: "", null: false
    t.string   "weight",             limit: 255,   default: "", null: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "photo_file_name",    limit: 255
    t.string   "photo_content_type", limit: 255
    t.integer  "photo_file_size",    limit: 4
    t.datetime "photo_updated_at"
    t.string   "type_of_state",      limit: 255
  end

  create_table "sale_products", force: :cascade do |t|
    t.float    "price",      limit: 24
    t.integer  "sale_id",    limit: 4
    t.integer  "product_id", limit: 4
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "quantity",   limit: 4,  default: 0
  end

  add_index "sale_products", ["product_id"], name: "index_sale_products_on_product_id", using: :btree
  add_index "sale_products", ["sale_id", "product_id"], name: "index_sale_products_on_sale_id_and_product_id", unique: true, using: :btree
  add_index "sale_products", ["sale_id"], name: "index_sale_products_on_sale_id", using: :btree

  create_table "sales", force: :cascade do |t|
    t.float    "total_value",        limit: 24
    t.float    "delivery_value",     limit: 24
    t.string   "status",             limit: 255
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "client_id",          limit: 4
    t.integer  "store_id",           limit: 4
    t.integer  "address_id",         limit: 4
    t.float    "change",             limit: 24,  default: 0.0
    t.string   "delivery_limit",     limit: 255, default: ""
    t.integer  "form_of_payment_id", limit: 4
    t.string   "motivation",         limit: 255
  end

  add_index "sales", ["address_id"], name: "index_sales_on_address_id", using: :btree
  add_index "sales", ["client_id"], name: "index_sales_on_client_id", using: :btree
  add_index "sales", ["form_of_payment_id"], name: "index_sales_on_form_of_payment_id", using: :btree
  add_index "sales", ["store_id"], name: "index_sales_on_store_id", using: :btree

  create_table "store_products", force: :cascade do |t|
    t.float    "price",                 limit: 24
    t.integer  "store_id",              limit: 4
    t.integer  "product_id",            limit: 4
    t.integer  "on_sale_percentage_id", limit: 4
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "store_products", ["on_sale_percentage_id"], name: "index_store_products_on_on_sale_percentage_id", using: :btree
  add_index "store_products", ["product_id"], name: "index_store_products_on_product_id", using: :btree
  add_index "store_products", ["store_id", "product_id", "on_sale_percentage_id"], name: "index_unique_store_products", unique: true, using: :btree
  add_index "store_products", ["store_id"], name: "index_store_products_on_store_id", using: :btree

  create_table "stores", force: :cascade do |t|
    t.string   "email",                     limit: 255, default: "",    null: false
    t.string   "encrypted_password",        limit: 255, default: "",    null: false
    t.string   "reset_password_token",      limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",             limit: 4,   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",        limit: 255
    t.string   "last_sign_in_ip",           limit: 255
    t.string   "name",                      limit: 255, default: "",    null: false
    t.string   "name_responsible",          limit: 255, default: "",    null: false
    t.string   "cnpj",                      limit: 255
    t.string   "instagram",                 limit: 255
    t.string   "facebook",                  limit: 255
    t.string   "site",                      limit: 255
    t.string   "telephone",                 limit: 255, default: "",    null: false
    t.integer  "count_canceled_purchases",  limit: 4,   default: 0,     null: false
    t.integer  "count_confirmed_purchases", limit: 4,   default: 0,     null: false
    t.boolean  "delivery",                              default: false, null: false
    t.boolean  "reserve",                               default: false, null: false
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.string   "photo_file_name",           limit: 255
    t.string   "photo_content_type",        limit: 255
    t.integer  "photo_file_size",           limit: 4
    t.datetime "photo_updated_at"
    t.string   "auth_token",                limit: 255, default: ""
    t.boolean  "active",                                default: false
    t.float    "value_per_km",              limit: 24
  end

  add_index "stores", ["auth_token"], name: "index_stores_on_auth_token", unique: true, using: :btree
  add_index "stores", ["email"], name: "index_stores_on_email", unique: true, using: :btree
  add_index "stores", ["reset_password_token"], name: "index_stores_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "form_of_payment_of_stores", "form_of_payments"
  add_foreign_key "form_of_payment_of_stores", "stores"
  add_foreign_key "sale_products", "products"
  add_foreign_key "sale_products", "sales"
  add_foreign_key "store_products", "on_sale_percentages"
  add_foreign_key "store_products", "products"
  add_foreign_key "store_products", "stores"
end
