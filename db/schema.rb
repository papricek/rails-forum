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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130203225225) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "forums", :force => true do |t|
    t.string  "name"
    t.text    "description"
    t.integer "views_count", :default => 0
    t.string  "slug"
    t.integer "category_id"
    t.integer "sort",        :default => 0
  end

  add_index "forums", ["slug"], :name => "index_forem_forums_on_slug", :unique => true

  create_table "posts", :force => true do |t|
    t.integer  "topic_id"
    t.text     "text"
    t.integer  "user_id"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "reply_to_id"
    t.string   "state",       :default => "pending_review"
    t.boolean  "notified",    :default => false
  end

  add_index "posts", ["reply_to_id"], :name => "index_forem_posts_on_reply_to_id"
  add_index "posts", ["state"], :name => "index_forem_posts_on_state"
  add_index "posts", ["topic_id"], :name => "index_forem_posts_on_topic_id"
  add_index "posts", ["user_id"], :name => "index_forem_posts_on_user_id"

  create_table "subscriptions", :force => true do |t|
    t.integer "subscriber_id"
    t.integer "topic_id"
  end

  create_table "topics", :force => true do |t|
    t.integer  "forum_id"
    t.integer  "user_id"
    t.string   "subject"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.boolean  "locked",       :default => false,            :null => false
    t.boolean  "pinned",       :default => false
    t.boolean  "hidden",       :default => false
      t.datetime "last_post_at"
    t.string   "state",        :default => "pending_review"
    t.integer  "views_count",  :default => 0
    t.string   "slug"
  end

  add_index "topics", ["forum_id"], :name => "index_forem_topics_on_forum_id"
  add_index "topics", ["slug"], :name => "index_forem_topics_on_slug", :unique => true
  add_index "topics", ["state"], :name => "index_forem_topics_on_state"
  add_index "topics", ["user_id"], :name => "index_forem_topics_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",               :null => false
    t.string   "encrypted_password",     :default => "",               :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.boolean  "admin",                  :default => false
    t.string   "state",                  :default => "pending_review"
    t.boolean  "auto_subscribe",         :default => false
    t.string   "role"
    t.string   "name"
    t.string   "url"
    t.string   "nick"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "views", :force => true do |t|
    t.integer  "user_id"
    t.integer  "viewable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "count",             :default => 0
    t.string   "viewable_type"
    t.datetime "current_viewed_at"
    t.datetime "past_viewed_at"
  end

  add_index "views", ["updated_at"], :name => "index_forem_views_on_updated_at"
  add_index "views", ["user_id"], :name => "index_forem_views_on_user_id"
  add_index "views", ["viewable_id"], :name => "index_forem_views_on_topic_id"

end
