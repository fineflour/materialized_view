class CreateDatabaseStructure < ActiveRecord::Migration
  def up 
    create_table :database_structures do |t|
      ActiveRecord::Schema.define(version: 20160203163612) do

        # These are extensions that must be enabled in order to support this database
        enable_extension "plpgsql"

        create_table "address_transitions", force: :cascade do |t|
          t.string   "to_state",           limit: 255
          t.text     "metadata",                       default: "{}"
          t.integer  "sort_key"
          t.integer  "order_exception_id"
          t.datetime "created_at"
          t.datetime "updated_at"
        end

        add_index "address_transitions", ["order_exception_id"], name: "index_address_transitions_on_order_exception_id", using: :btree
        add_index "address_transitions", ["sort_key", "order_exception_id"], name: "index_address_transitions_on_sort_key_and_order_exception_id", unique: true, using: :btree

        create_table "api_request_logs", force: :cascade do |t|
          t.text     "request"
          t.datetime "created_at"
          t.datetime "updated_at"
        end

        create_table "blacklisted_addresses", force: :cascade do |t|
          t.string   "delivery_point_barcode", limit: 255
          t.datetime "created_at"
          t.datetime "updated_at"
          t.integer  "order_id"
        end

        create_table "delayed_jobs", force: :cascade do |t|
          t.integer  "priority",               default: 0, null: false
          t.integer  "attempts",               default: 0, null: false
          t.text     "handler",                            null: false
          t.text     "last_error"
          t.datetime "run_at"
          t.datetime "locked_at"
          t.datetime "failed_at"
          t.string   "locked_by",  limit: 255
          t.string   "queue",      limit: 255
          t.datetime "created_at"
          t.datetime "updated_at"
        end

        add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

        create_table "distribution_centers", force: :cascade do |t|
          t.string   "name",       limit: 255
          t.datetime "created_at"
          t.datetime "updated_at"
        end

        create_table "exception_logs", force: :cascade do |t|
          t.integer  "rake_task_duration"
          t.integer  "address_exception_found"
          t.string   "log_summary",             limit: 255
          t.datetime "created_at"
          t.datetime "updated_at"
          t.integer  "total_ops_checked"
          t.integer  "limit_exception_found"
          t.integer  "total_orders"
        end

        create_table "impb_configurations", force: :cascade do |t|
          t.integer  "piece_start_number"
          t.integer  "container_start_number"
          t.datetime "created_at"
          t.datetime "updated_at"
        end

        create_table "inventory_adjustments", force: :cascade do |t|
          t.integer  "quantity"
          t.text     "description"
          t.datetime "created_at"
          t.datetime "updated_at"
          t.integer  "material_id"
          t.integer  "user_id"
        end

        create_table "mailing_configurations", force: :cascade do |t|
          t.integer  "minimum_size"
          t.string   "kind",                    limit: 255
          t.datetime "created_at"
          t.datetime "updated_at"
          t.string   "label_model_number",      limit: 255
          t.integer  "max_address_line_length"
          t.string   "distribution",            limit: 255
          t.integer  "maximum_size"
          t.float    "weight"
          t.integer  "labels_per_sheet"
        end

        add_index "mailing_configurations", ["kind"], name: "index_mailing_configurations_on_kind", unique: true, using: :btree

        create_table "materials", force: :cascade do |t|
          t.string   "name",                   limit: 255
          t.text     "description"
          t.string   "language",               limit: 255
          t.float    "weight"
          t.float    "length"
          t.float    "height"
          t.float    "width"
          t.datetime "created_at"
          t.datetime "updated_at"
          t.string   "shortname",              limit: 255
          t.boolean  "active",                             default: true
          t.integer  "quantity",                           default: 0
          t.integer  "velocity_30_day",                    default: 0
          t.integer  "velocity_60_day",                    default: 0
          t.integer  "velocity_90_day",                    default: 0
          t.integer  "velocity_180_day",                   default: 0
          t.integer  "census_quantity"
          t.datetime "censused_at"
          t.integer  "distribution_center_id"
        end

        create_table "non_ops_distribution_totals", force: :cascade do |t|
          t.integer  "product"
          t.integer  "total"
          t.string   "note",        limit: 255
          t.string   "entered_by",  limit: 255
          t.datetime "report_date"
          t.datetime "created_at"
          t.datetime "updated_at"
        end

        create_table "notes", force: :cascade do |t|
          t.text     "content"
          t.integer  "order_id"
          t.datetime "created_at"
          t.datetime "updated_at"
          t.string   "entered_by", limit: 255
        end

        add_index "notes", ["order_id"], name: "index_notes_on_order_id", using: :btree

        create_table "order_exceptions", force: :cascade do |t|
          t.integer  "orderproduct_id"
          t.string   "type",            limit: 255
          t.datetime "created_at"
          t.datetime "updated_at"
        end

        add_index "order_exceptions", ["id", "type"], name: "index_order_exceptions_on_id_and_type", using: :btree
        add_index "order_exceptions", ["orderproduct_id"], name: "index_order_exceptions_on_orderproduct_id", using: :btree

        create_table "orderproduct_transitions", force: :cascade do |t|
          t.string   "to_state",        limit: 255
          t.text     "metadata",                    default: "{}"
          t.integer  "sort_key"
          t.integer  "orderproduct_id"
          t.datetime "created_at"
          t.datetime "updated_at"
        end

        add_index "orderproduct_transitions", ["orderproduct_id"], name: "index_orderproduct_transitions_on_orderproduct_id", using: :btree
        add_index "orderproduct_transitions", ["sort_key", "orderproduct_id"], name: "index_orderproduct_transitions_on_sort_key_and_orderproduct_id", unique: true, using: :btree

        create_table "orderproducts", force: :cascade do |t|
          t.integer  "order_id"
          t.integer  "product_id"
          t.datetime "created_at"
          t.datetime "updated_at"
          t.integer  "pallet_id"
          t.integer  "legacy_id"
          t.string   "current_state", limit: 255
        end

        add_index "orderproducts", ["current_state"], name: "index_orderproducts_on_current_state", using: :btree
        add_index "orderproducts", ["legacy_id"], name: "index_orderproducts_on_legacy_id", using: :btree
        add_index "orderproducts", ["order_id", "product_id"], name: "index_orderproducts_on_order_id_and_product_id", using: :btree
        add_index "orderproducts", ["order_id"], name: "index_orderproducts_on_order_id", using: :btree
        add_index "orderproducts", ["pallet_id"], name: "index_orderproducts_on_pallet_id", using: :btree
        add_index "orderproducts", ["product_id"], name: "index_orderproducts_on_product_id", using: :btree

        create_table "orders", force: :cascade do |t|
          t.string   "firstname",                limit: 255
          t.string   "lastname",                 limit: 255
          t.string   "address1",                 limit: 255
          t.string   "address2",                 limit: 255
          t.string   "city",                     limit: 255
          t.string   "state",                    limit: 255
          t.string   "zip",                      limit: 255
          t.datetime "created_at"
          t.datetime "updated_at"
          t.string   "email",                    limit: 255
          t.string   "address_hash",             limit: 255
          t.string   "name_hash",                limit: 255
          t.integer  "legacy_id"
          t.string   "phone",                    limit: 255
          t.string   "request_method",           limit: 255
          t.text     "search_body"
          t.string   "language_spoken",          limit: 255
          t.string   "how_heard",                limit: 255
          t.boolean  "requests_further_contact",             default: false
          t.boolean  "skip_limit_check",                     default: false
          t.string   "delivery_type",            limit: 255, default: "bulk"
          t.string   "type",                     limit: 255
          t.string   "ip_address",               limit: 255
          t.float    "latitude"
          t.float    "longitude"
          t.datetime "geocoded_at"
        end

        add_index "orders", ["created_at"], name: "index_orders_on_created_at", using: :btree
        add_index "orders", ["legacy_id"], name: "index_orders_on_legacy_id", using: :btree

        create_table "pallets", force: :cascade do |t|
          t.datetime "shipped_at"
          t.string   "status",                   limit: 255
          t.datetime "created_at"
          t.datetime "updated_at"
          t.text     "address_label_data"
          t.integer  "mailing_configuration_id"
          t.integer  "legacy_id"
          t.integer  "impb_configuration_id"
        end

        add_index "pallets", ["created_at"], name: "index_pallets_on_created_at", using: :btree
        add_index "pallets", ["impb_configuration_id"], name: "index_pallets_on_impb_configuration_id", using: :btree
        add_index "pallets", ["legacy_id"], name: "index_pallets_on_legacy_id", using: :btree
        add_index "pallets", ["mailing_configuration_id"], name: "index_pallets_on_mailing_configuration_id", using: :btree

        create_table "product_materials", force: :cascade do |t|
          t.integer  "product_id"
          t.integer  "material_id"
          t.datetime "created_at"
          t.datetime "updated_at"
        end

        add_index "product_materials", ["material_id"], name: "index_product_materials_on_material_id", using: :btree
        add_index "product_materials", ["product_id"], name: "index_product_materials_on_product_id", using: :btree

        create_table "products", force: :cascade do |t|
          t.string   "name",                     limit: 255
          t.string   "shortname",                limit: 255
          t.boolean  "active",                               default: true
          t.text     "description"
          t.string   "language",                 limit: 255
          t.string   "author",                   limit: 255
          t.datetime "created_at"
          t.datetime "updated_at"
          t.integer  "mailing_configuration_id"
        end

        add_index "products", ["mailing_configuration_id"], name: "index_products_on_mailing_configuration_id", using: :btree

        create_table "reports", force: :cascade do |t|
          t.string   "name",            limit: 255
          t.text     "cities"
          t.date     "begin_date"
          t.date     "end_date"
          t.datetime "created_at"
          t.datetime "updated_at"
          t.string   "state",           limit: 255
          t.string   "filters",         limit: 255
          t.string   "language_spoken", limit: 255
        end

        create_table "smarty_streets_responses", force: :cascade do |t|
          t.string   "match_code",             limit: 255
          t.text     "footnotes"
          t.integer  "order_id"
          t.datetime "created_at"
          t.datetime "updated_at"
          t.string   "record_type",            limit: 255
          t.string   "zip_type",               limit: 255
          t.string   "county_fips",            limit: 255
          t.string   "county_name",            limit: 255
          t.string   "carrier_route",          limit: 255
          t.string   "congressional_district", limit: 255
          t.string   "rdi",                    limit: 255
          t.string   "elot_sequence",          limit: 255
          t.string   "elot_sort",              limit: 255
          t.float    "latitude"
          t.float    "longitude"
          t.string   "precision",              limit: 255
          t.string   "time_zone",              limit: 255
          t.integer  "utc_offset"
          t.boolean  "dst"
          t.string   "delivery_point_barcode", limit: 255
        end

        add_index "smarty_streets_responses", ["order_id"], name: "index_smarty_streets_responses_on_order_id", using: :btree

        create_table "uniquecities", force: :cascade do |t|
          t.string   "city",       limit: 255
          t.string   "state",      limit: 255
          t.datetime "created_at"
          t.datetime "updated_at"
        end

        create_table "users", force: :cascade do |t|
          t.string   "email",                  limit: 255, default: "", null: false
          t.string   "encrypted_password",     limit: 255, default: "", null: false
          t.string   "reset_password_token",   limit: 255
          t.datetime "reset_password_sent_at"
          t.datetime "remember_created_at"
          t.integer  "sign_in_count",                      default: 0,  null: false
          t.datetime "current_sign_in_at"
          t.datetime "last_sign_in_at"
          t.string   "current_sign_in_ip",     limit: 255
          t.string   "last_sign_in_ip",        limit: 255
          t.datetime "created_at"
          t.datetime "updated_at"
          t.string   "name",                   limit: 255
          t.integer  "role",                               default: 0
        end

        add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
        add_index "users", ["name"], name: "index_users_on_name", using: :btree
        add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

        create_table "versions", force: :cascade do |t|
          t.string   "item_type",      limit: 255, null: false
          t.integer  "item_id",                    null: false
          t.string   "event",          limit: 255, null: false
          t.string   "whodunnit",      limit: 255
          t.text     "object"
          t.datetime "created_at"
          t.text     "object_changes"
        end

        add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

      end
  end

    def down
    end
  end
end
