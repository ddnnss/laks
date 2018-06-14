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

ActiveRecord::Schema.define(version: 20180614180809) do

  create_table "aktions", force: :cascade do |t|
    t.string "aktion_name"
    t.string "aktion_name_translit"
    t.string "aktion_expire"
    t.string "aktion_image"
  end

  create_table "categories", force: :cascade do |t|
    t.string "cat_name", default: ""
    t.string "cat_name_translit", default: ""
    t.string "cat_image", default: ""
    t.text "cat_page_title", default: ""
    t.text "cat_page_description", default: ""
    t.text "cat_description", default: ""
    t.integer "cat_views", default: 0
    t.boolean "show_in_menu", default: false
    t.index ["cat_name"], name: "index_categories_on_cat_name"
    t.index ["cat_name_translit"], name: "index_categories_on_cat_name_translit"
    t.index ["show_in_menu"], name: "index_categories_on_show_in_menu"
  end

  create_table "clients", force: :cascade do |t|
    t.string "client_email"
    t.string "client_name", default: ""
    t.string "client_family", default: ""
    t.string "client_ot4estvo", default: ""
    t.string "client_passport", default: ""
    t.string "client_phone", default: ""
    t.string "client_country", default: ""
    t.string "client_city", default: ""
    t.string "client_post_code", default: ""
    t.string "client_address", default: ""
    t.string "client_password"
    t.string "client_view_history", default: ""
    t.string "client_wishlist", default: ""
    t.date "client_last_login"
    t.text "client_cart_items"
    t.text "client_comment", default: ""
    t.boolean "client_vip", default: false
    t.boolean "client_mail_subscribe", default: true
    t.boolean "client_activated", default: false
    t.boolean "client_admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_email"], name: "index_clients_on_client_email"
  end

  create_table "collections", force: :cascade do |t|
    t.string "collection_name", default: ""
    t.string "collection_name_translit", default: ""
    t.string "collection_image", default: ""
    t.integer "collection_views", default: 0
    t.text "collection_page_title", default: ""
    t.text "collection_page_description", default: ""
    t.text "collection_description", default: ""
    t.index ["collection_name"], name: "index_collections_on_collection_name"
    t.index ["collection_name_translit"], name: "index_collections_on_collection_name_translit"
  end

  create_table "discounts", force: :cascade do |t|
    t.string "discount_code"
    t.string "discount_discount_value"
    t.boolean "discount_for_one_use"
    t.date "discount_expiry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discount_code"], name: "index_discounts_on_discount_code"
  end

  create_table "homepages", force: :cascade do |t|
  end

  create_table "items", force: :cascade do |t|
    t.integer "subcategory_id"
    t.integer "collection_id"
    t.string "item_name"
    t.string "item_name_caps"
    t.string "item_name_translit", default: ""
    t.string "item_image1", default: "none"
    t.string "item_image2", default: "none"
    t.string "item_image3", default: "none"
    t.string "item_image4", default: "none"
    t.string "item_size", default: "не указано"
    t.string "item_article", default: "не указано"
    t.string "item_weight", default: "не указано"
    t.string "item_color", default: "не указано"
    t.text "item_description", default: ""
    t.string "item_page_title", default: ""
    t.string "item_page_description", default: ""
    t.integer "item_price"
    t.integer "item_opt_price"
    t.integer "item_opt_price_count"
    t.integer "item_discount", default: 0
    t.integer "item_views_count", default: 0
    t.boolean "item_in_sale", default: false
    t.boolean "item_in_collection", default: false
    t.boolean "item_new", default: false
    t.boolean "item_presents", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collection_id"], name: "index_items_on_collection_id"
    t.index ["item_in_collection"], name: "index_items_on_item_in_collection"
    t.index ["item_in_sale"], name: "index_items_on_item_in_sale"
    t.index ["item_name_caps"], name: "index_items_on_item_name_caps"
    t.index ["item_name_translit"], name: "index_items_on_item_name_translit"
    t.index ["item_new"], name: "index_items_on_item_new"
    t.index ["item_price"], name: "index_items_on_item_price"
    t.index ["subcategory_id"], name: "index_items_on_subcategory_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "client_id"
    t.text "order_items"
    t.string "order_status"
    t.string "order_summ"
    t.string "order_discount_code"
    t.text "order_guest_data"
    t.string "order_dostavka"
    t.string "order_oplata"
    t.string "order_tracking"
    t.string "order_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_orders_on_client_id"
    t.index ["order_number"], name: "index_orders_on_order_number"
    t.index ["order_status"], name: "index_orders_on_order_status"
    t.index ["order_tracking"], name: "index_orders_on_order_tracking"
  end

  create_table "sliders", force: :cascade do |t|
    t.string "slider_image"
    t.string "slider_text1"
    t.string "slider_text2"
    t.string "slider_text3"
    t.string "slider_url"
  end

  create_table "subcategories", force: :cascade do |t|
    t.integer "category_id"
    t.string "subcat_name", default: ""
    t.string "subcat_name_translit", default: ""
    t.string "subcat_image", default: ""
    t.integer "subcat_views", default: 0
    t.text "subcat_page_title", default: ""
    t.text "subcat_page_description", default: ""
    t.text "subcat_description", default: ""
    t.index ["category_id"], name: "index_subcategories_on_category_id"
    t.index ["subcat_name"], name: "index_subcategories_on_subcat_name"
    t.index ["subcat_name_translit"], name: "index_subcategories_on_subcat_name_translit"
  end

end
