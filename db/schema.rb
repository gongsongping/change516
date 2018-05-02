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

ActiveRecord::Schema.define(version: 20180409190929) do

  create_table "askertargets", force: :cascade do |t|
    t.integer "asker_id"
    t.integer "target_id"
    t.boolean "agree"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asker_id"], name: "index_askertargets_on_asker_id"
    t.index ["target_id"], name: "index_askertargets_on_target_id"
  end

  create_table "cafecmts", force: :cascade do |t|
    t.string "content"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_cafecmts_on_user_id"
  end

  create_table "cafeposts", force: :cascade do |t|
    t.integer "user_id"
    t.string "content"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_cafeposts_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.string "content"
    t.integer "post_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.boolean "done"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "photos", force: :cascade do |t|
    t.string "url"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_photos_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.text "content"
    t.boolean "hidden", default: false
    t.string "json"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "productcmts", force: :cascade do |t|
    t.string "content"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_productcmts_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.text "content"
    t.string "url"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_products_on_user_id"
  end

  create_table "stalkertargets", force: :cascade do |t|
    t.integer "stalker_id"
    t.integer "target_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stalker_id"], name: "index_stalkertargets_on_stalker_id"
    t.index ["target_id"], name: "index_stalkertargets_on_target_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "token"
    t.string "json"
    t.string "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nationality"
    t.string "city"
    t.integer "age"
    t.string "telenumber"
    t.string "description"
    t.boolean "cafeshop"
    t.boolean "admin"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["token"], name: "index_users_on_token"
  end

end
