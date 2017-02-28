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

ActiveRecord::Schema.define(version: 20170228040436) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.integer  "question_id"
    t.string   "question_type"
    t.integer  "answer_entry"
    t.integer  "response_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["question_id", "question_type"], name: "index_answers_on_question_id_and_question_type", using: :btree
    t.index ["response_id"], name: "index_answers_on_response_id", using: :btree
  end

  create_table "mcqs", force: :cascade do |t|
    t.string   "question_text",                   null: false
    t.boolean  "required"
    t.boolean  "multiselect"
    t.integer  "survey_id"
    t.boolean  "shuffle_options", default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["survey_id"], name: "index_mcqs_on_survey_id", using: :btree
  end

  create_table "nrqs", force: :cascade do |t|
    t.string   "question_text", null: false
    t.boolean  "required"
    t.integer  "min",           null: false
    t.integer  "max",           null: false
    t.integer  "survey_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["survey_id"], name: "index_nrqs_on_survey_id", using: :btree
  end

  create_table "options", force: :cascade do |t|
    t.string   "option_text", null: false
    t.integer  "mcq_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["mcq_id"], name: "index_options_on_mcq_id", using: :btree
  end

  create_table "responses", force: :cascade do |t|
    t.integer  "survey_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_id"], name: "index_responses_on_survey_id", using: :btree
  end

  create_table "surveys", force: :cascade do |t|
    t.string   "title",                             null: false
    t.text     "description"
    t.datetime "published_on"
    t.boolean  "shuffle_questions", default: false
    t.integer  "responses_count",   default: 0,     null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["title"], name: "index_surveys_on_title", unique: true, using: :btree
  end

end
