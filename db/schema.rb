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

ActiveRecord::Schema.define(:version => 20140216182352) do

  create_table "ad_questionnaires", :force => true do |t|
    t.integer  "coupon_id"
    t.string   "question"
    t.string   "answers"
    t.string   "correct_answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "addresses", :force => true do |t|
    t.integer  "user_id"
    t.string   "address"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "mobile"
    t.string   "fax"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.text     "billing_addr"
    t.text     "shipping_addr"
    t.string   "latilong"
  end

  create_table "amenities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "area_city_wise", :force => true do |t|
    t.integer  "city"
    t.string   "near_by_location"
    t.string   "pincode"
    t.integer  "is_metro",         :limit => 1, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "latilong"
  end

  create_table "banner_ads", :force => true do |t|
    t.string   "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "publish"
    t.string   "sponsor"
    t.string   "target_url"
    t.integer  "user_id"
    t.integer  "max_impression"
    t.integer  "imp_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "banner_img_file_name"
    t.string   "banner_img_content_type"
    t.integer  "banner_img_file_size"
    t.datetime "banner_img_updated_at"
  end

  create_table "bought_coupons", :force => true do |t|
    t.integer  "user_id"
    t.integer  "deal_id"
    t.integer  "coupon_id"
    t.string   "security_code"
    t.string   "verified"
    t.string   "tracking_info"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "transaction_code"
    t.boolean  "trn_completed"
    t.string   "payment_type"
    t.float    "trn_amount",         :default => 0.0
    t.string   "bought_coupon_root", :default => "http://mydeals247.com"
    t.string   "currency_code"
    t.float    "exchange_rate",      :default => 65.0388
  end

  create_table "bought_deals", :force => true do |t|
    t.integer  "user_id"
    t.integer  "deal_id"
    t.float    "bought_price"
    t.string   "security_code"
    t.string   "verified"
    t.string   "tracking_info"
    t.string   "transaction_code"
    t.boolean  "trn_completed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity"
    t.float    "discount"
    t.string   "payment_type"
    t.boolean  "seller_payment_status"
    t.boolean  "status"
    t.text     "seller_payment_note_by_admin"
    t.float    "ad_redeem_amt",                             :default => 0.0
    t.integer  "is_franchisee_partner",        :limit => 1, :default => 0
    t.float    "vat_percent",                               :default => 0.0
    t.float    "service_tax_percent",                       :default => 0.0
    t.float    "other_tax_percent",                         :default => 0.0
    t.float    "paid_to_merchant",                          :default => 0.0
    t.float    "commision_percent",                         :default => 0.0
    t.float    "additional_shipping_cost",                  :default => 0.0
    t.string   "bought_deal_voucher_root",                  :default => "http://mydeals247.com"
    t.string   "currency_code"
    t.float    "exchange_rate",                             :default => 65.0388
  end

  create_table "bought_offers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "user_request_id"
    t.integer  "merchant_offer_id"
    t.integer  "merchant_id"
    t.float    "bought_price"
    t.string   "security_code"
    t.string   "purchase_code"
    t.string   "verified"
    t.boolean  "trn_completed"
    t.boolean  "status"
    t.string   "transaction_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "seller_payment_status"
    t.boolean  "shipping_flag"
    t.string   "courier_name"
    t.string   "tracking_number"
    t.string   "courier_url"
    t.string   "payment_type"
    t.text     "seller_payment_note_by_admin"
    t.float    "ad_redeem_amt",                             :default => 0.0
    t.integer  "is_franchisee_partner",        :limit => 1, :default => 0
    t.float    "vat_percent",                               :default => 0.0
    t.float    "service_tax_percent",                       :default => 0.0
    t.float    "other_tax_percent",                         :default => 0.0
    t.float    "paid_to_merchant",                          :default => 0.0
    t.float    "commision_percent",                         :default => 0.0
    t.float    "additional_shipping_cost",                  :default => 0.0
    t.text     "offline_payment_note"
    t.string   "voucher_root",                              :default => "http://mydeals247.com"
    t.string   "currency_code"
    t.float    "exchange_rate",                             :default => 65.0388
  end

  create_table "bought_offline_coupons", :force => true do |t|
    t.integer  "user_id"
    t.integer  "coupon_id"
    t.string   "payment_mode"
    t.string   "verified"
    t.float    "trn_amount"
    t.text     "txn_remark"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "currency_code"
    t.float    "exchange_rate", :default => 65.0388
  end

  create_table "bought_offline_deals", :force => true do |t|
    t.integer  "user_id"
    t.integer  "deal_id"
    t.integer  "bought_deal_id"
    t.integer  "split"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity"
    t.float    "discount"
    t.string   "payment_type"
    t.boolean  "status"
    t.boolean  "admin_status"
    t.text     "payment_note_by_buyer"
    t.text     "payment_note_by_admin"
    t.float    "ad_redeem_amt"
    t.string   "currency_code"
    t.float    "exchange_rate",         :default => 65.0388
  end

  create_table "buysell_categories", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "mydeals_fee",                           :precision => 10, :scale => 2, :default => 0.0
    t.string   "color_code"
    t.integer  "is_active",                :limit => 1,                                :default => 1
    t.string   "thumbnail_img_gray"
    t.string   "thumbnail_img_highlight"
    t.string   "thumbnail_img_background"
    t.integer  "position",                                                             :default => 9999
    t.string   "crm_productGroup_id"
    t.integer  "shown_to_user",            :limit => 1,                                :default => 1
    t.string   "item_header_img"
    t.string   "item_bottom_img"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "status",                  :default => true
    t.integer  "is_new",     :limit => 1, :default => 0
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "currency"
    t.string   "std_code"
    t.integer  "is_active",  :limit => 1, :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coupon_locations", :force => true do |t|
    t.integer  "coupon_id"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.float    "amount_allocated"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "latilong"
  end

  create_table "coupons", :force => true do |t|
    t.string   "name"
    t.integer  "category_id"
    t.integer  "merchant_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "barcode"
    t.string   "zipcode"
    t.integer  "max_qty"
    t.integer  "bought_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "coupon_img_file_name"
    t.string   "coupon_img_content_type"
    t.integer  "coupon_img_file_size"
    t.datetime "coupon_img_updated_at"
    t.integer  "location_id"
    t.boolean  "negotiation"
    t.float    "admin_price"
    t.float    "user_price"
    t.text     "description"
    t.boolean  "status"
    t.boolean  "trn_status"
    t.boolean  "publish"
    t.string   "target_url"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.boolean  "change_img",                             :default => false
    t.boolean  "publish_fee",                            :default => false
    t.boolean  "free_publish_fee",                       :default => false
    t.boolean  "seller_approve",                         :default => false
    t.boolean  "ads_type",                               :default => false
    t.string   "video_url"
    t.text     "ad_quiz_info"
    t.integer  "is_accross_country",        :limit => 1, :default => 0
    t.float    "per_quiz_cost"
    t.float    "quiz_balance_amount"
    t.string   "payment_mode"
    t.text     "payment_remark"
    t.string   "target_employment_status"
    t.string   "target_age_group"
    t.string   "target_gender"
    t.string   "volume_deal_url"
    t.string   "ad_detail_field_name"
    t.integer  "admin_payment_verified",    :limit => 1, :default => 0
    t.text     "admin_payment_verf_remark"
    t.string   "ad_img_root",                            :default => "http://mydeals247.com"
    t.datetime "last_balance_notif",                     :default => '2013-02-10 20:22:14'
    t.integer  "is_accross_state",          :limit => 1, :default => 1
    t.string   "currency_code"
    t.float    "exchange_rate",                          :default => 65.0388
    t.string   "latilong"
  end

  create_table "crm_refs", :force => true do |t|
    t.integer  "user_id"
    t.string   "crm_location_id"
    t.string   "crm_salesAC_id"
    t.string   "crm_contact_party_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "crm_contact_resource_id"
  end

  create_table "deal_comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "deal_id"
    t.text     "comments"
    t.boolean  "publish"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deal_configurations", :force => true do |t|
    t.integer  "deal_id"
    t.string   "config_param_name"
    t.string   "config_param_value"
    t.integer  "is_active",          :limit => 1, :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deals", :force => true do |t|
    t.string   "name"
    t.integer  "category_id"
    t.integer  "merchant_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.float    "actual_price"
    t.float    "base_price"
    t.float    "shipping"
    t.string   "discount"
    t.integer  "max_qty"
    t.string   "zipcode"
    t.integer  "bought_count"
    t.string   "addl_disc_offr"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "deal_img_file_name"
    t.string   "deal_img_content_type"
    t.integer  "deal_img_file_size"
    t.datetime "deal_img_updated_at"
    t.boolean  "publish"
    t.boolean  "hide_merchant_info"
    t.text     "admin_info"
    t.string   "uid"
    t.integer  "location_id"
    t.boolean  "split_coupon"
    t.text     "merchant_info"
    t.boolean  "negotiation"
    t.float    "admin_price"
    t.float    "user_price"
    t.boolean  "trn_status"
    t.boolean  "status"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.text     "url"
    t.text     "highlights"
    t.text     "fine_print"
    t.text     "terms_conditions"
    t.boolean  "expiry_info"
    t.string   "vcode_file_name"
    t.string   "vcode_content_type"
    t.integer  "vcode_file_size"
    t.datetime "vcode_updated_at"
    t.boolean  "voucher_flag"
    t.integer  "is_offline",            :limit => 1, :default => 0
    t.integer  "is_template",           :limit => 1, :default => 0
    t.integer  "is_hotDeal",            :limit => 1, :default => 0
    t.integer  "is_accross_country",    :limit => 1, :default => 0
    t.string   "deal_img_root",                      :default => "http://mydeals247.com"
    t.string   "product_type",                       :default => "vouchers"
    t.string   "currency_code"
    t.float    "exchange_rate",                      :default => 65.0388
    t.string   "item_unit"
    t.string   "latilong"
  end

  create_table "education_specializations", :force => true do |t|
    t.integer  "is_blocked",             :limit => 1, :default => 0
    t.string   "name"
    t.integer  "parent_id"
    t.string   "color_code"
    t.string   "icon"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rgt",                                 :default => 0
    t.integer  "lft"
    t.integer  "created_by",                          :default => 0
    t.integer  "approved_by",                         :default => 0
    t.integer  "qualification_level_id",              :default => 0
  end

  create_table "email_configs", :force => true do |t|
    t.text     "send_voucher_to_user"
    t.text     "disapproval_mail_to_user"
    t.text     "free_ads_mail_to_user"
    t.text     "shipped_order"
    t.text     "top_ranking_to_buyer"
    t.text     "top_ranking_to_seller"
    t.text     "tracking_info_to_accounts"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "flight_booking_cancellation_policy"
    t.text     "cab_booking_policy"
    t.text     "daily_deal_confirm_item"
  end

  create_table "email_configurations", :force => true do |t|
    t.text     "activation"
    t.text     "contact_us"
    t.text     "ad_success"
    t.text     "daily_deal_confirm"
    t.text     "send_voucher_to_user"
    t.text     "disapproval_mail_to_user"
    t.text     "forgot_pass"
    t.text     "free_ads_mail_to_user"
    t.text     "ads_mail_to_admin"
    t.text     "ads_mail_to_user"
    t.text     "offer_success"
    t.text     "ads_publish_to_user"
    t.text     "reject_offer"
    t.text     "order_confirmation"
    t.text     "shipped_order"
    t.text     "top_ranking_to_buyer"
    t.text     "top_ranking_to_seller"
    t.text     "tracking_info_to_accounts"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "hotel_booking_cancellation_policy"
  end

  create_table "email_sent_items", :force => true do |t|
    t.string   "to_user"
    t.string   "from_user"
    t.integer  "user_id"
    t.string   "of_location"
    t.string   "subject"
    t.text     "email_body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "no_of_users"
  end

  create_table "exchange_rates", :force => true do |t|
    t.string   "source",     :default => "USD"
    t.string   "target",     :default => "INR"
    t.float    "rate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "experience_levels", :force => true do |t|
    t.integer  "is_blocked",  :limit => 1, :default => 0
    t.string   "name"
    t.integer  "level"
    t.string   "color_code"
    t.string   "icon"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by",               :default => 0
    t.integer  "approved_by",              :default => 0
  end

  create_table "functional_areas", :force => true do |t|
    t.integer  "is_blocked",  :limit => 1, :default => 0
    t.string   "name"
    t.integer  "parent_id"
    t.string   "color_code"
    t.string   "icon"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "is_approved", :limit => 1, :default => 1
    t.integer  "lft",                      :default => 0
    t.integer  "rgt",                      :default => 0
    t.integer  "created_by",               :default => 0
    t.integer  "approved_by",              :default => 0
  end

  create_table "item_catalog_configs", :force => true do |t|
    t.integer  "item_catalog_id"
    t.string   "item_catalog_config_name"
    t.string   "item_catalog_config_values"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_catalog_specs", :force => true do |t|
    t.integer  "item_catalog_id"
    t.string   "item_catalog_spec_name"
    t.text     "item_catalog_spec_content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_catalogs", :force => true do |t|
    t.integer  "buysell_category_id"
    t.string   "item_name"
    t.string   "item_catalog_img_file_name"
    t.string   "item_catalog_img_content_type"
    t.integer  "item_catalog_img_file_size"
    t.datetime "item_catalog_img_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "item_description"
    t.integer  "publish",                       :limit => 1, :default => 1
    t.string   "user_id",                                    :default => "1"
  end

  create_table "job_applications", :force => true do |t|
    t.integer  "job_posting_id"
    t.integer  "job_profile_id"
    t.integer  "is_eligible",           :limit => 1, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "skill_match_percent"
    t.float    "profile_match_percent"
    t.string   "profile_match_str"
    t.string   "profile_unmatch_str"
    t.integer  "is_deleted",            :limit => 1, :default => 0
    t.integer  "is_shortlisted",        :limit => 1, :default => 0
    t.integer  "employer_viewed",       :limit => 1, :default => 0
    t.integer  "edu_matched",           :limit => 1, :default => 0
  end

  create_table "job_posting_education_prefs", :force => true do |t|
    t.integer  "job_posting_id"
    t.integer  "education_specialization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_posting_location_prefs", :force => true do |t|
    t.integer  "job_posting_id"
    t.string   "job_city"
    t.string   "job_state"
    t.string   "job_country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "latilong"
  end

  create_table "job_posting_questions", :force => true do |t|
    t.integer  "job_posting_id"
    t.string   "question"
    t.string   "answers"
    t.string   "correct_answer"
    t.integer  "is_mandatory",   :limit => 1, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_posting_skills", :force => true do |t|
    t.integer  "job_posting_id"
    t.string   "skill_name"
    t.integer  "min_experience"
    t.integer  "expert_level",   :limit => 1, :default => 0
    t.integer  "is_required",    :limit => 1, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_postings", :force => true do |t|
    t.integer  "user_id"
    t.string   "job_title"
    t.text     "job_description"
    t.integer  "condidate_type",              :limit => 1, :default => 0
    t.string   "job_type"
    t.integer  "qualification_level",         :limit => 1, :default => 0
    t.string   "education_specialization_id"
    t.float    "minimum_academic_perc"
    t.float    "min_salary"
    t.float    "max_salary"
    t.string   "gender"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "job_city"
    t.string   "job_state"
    t.string   "job_country"
    t.integer  "functional_area_id"
    t.integer  "minimum_experience"
    t.integer  "temp_user"
    t.string   "experience_level_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "no_of_position"
    t.integer  "is_publish",                  :limit => 1, :default => 0
    t.integer  "is_deleted",                  :limit => 1, :default => 0
    t.integer  "edu_match",                   :limit => 1, :default => 1
    t.string   "latilong"
  end

  create_table "job_profile_awards", :force => true do |t|
    t.integer  "job_profile_id"
    t.integer  "year_from"
    t.integer  "year_to"
    t.string   "award_title"
    t.text     "award_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_profile_education_prefs", :force => true do |t|
    t.integer  "job_profile_id"
    t.integer  "education_specialization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_profile_educations", :force => true do |t|
    t.integer  "job_profile_id"
    t.integer  "year_from"
    t.integer  "year_to"
    t.string   "edu_title"
    t.string   "institute"
    t.text     "edu_description"
    t.integer  "marks_perc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_profile_experiences", :force => true do |t|
    t.integer  "job_profile_id"
    t.integer  "year_from"
    t.integer  "year_to"
    t.string   "job_title"
    t.string   "company"
    t.text     "job_description"
    t.string   "your_role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_profile_functional_prefs", :force => true do |t|
    t.integer  "job_profile_id"
    t.integer  "functional_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_profile_location_prefs", :force => true do |t|
    t.integer  "job_profile_id"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "latilong"
  end

  create_table "job_profile_skills", :force => true do |t|
    t.integer  "job_profile_id"
    t.string   "skill_name"
    t.integer  "experience"
    t.integer  "expert_level",   :limit => 1, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "f_Name"
    t.string   "l_Name"
    t.string   "gender"
    t.string   "cur_city"
    t.string   "cur_state"
    t.string   "cur_country"
    t.integer  "is_experienced",           :limit => 1, :default => 0
    t.integer  "total_experience"
    t.float    "expected_salary"
    t.integer  "qualification_level",      :limit => 1, :default => 0
    t.string   "institute_name"
    t.string   "course_type"
    t.float    "percentage"
    t.string   "resume_doc"
    t.string   "job_title"
    t.string   "company_name"
    t.integer  "cur_job_duration"
    t.float    "current_salary"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "temp_job"
    t.string   "experience_level_id"
    t.string   "desired_job_type"
    t.string   "profile_img_file_name"
    t.string   "profile_img_content_type"
    t.integer  "profile_img_file_size"
    t.datetime "profile_img_updated_at"
    t.string   "latilong"
  end

  create_table "job_que_answers", :force => true do |t|
    t.integer  "job_posting_id"
    t.integer  "job_profile_id"
    t.integer  "job_posting_question_id"
    t.integer  "has_answered",            :limit => 1, :default => 0
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "job_application_id"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "master_data", :force => true do |t|
    t.string   "video_url"
    t.text     "national_ad_url"
    t.string   "currency_symbol"
    t.integer  "request_expiry_hrs"
    t.string   "buysell_transaction_fee"
    t.integer  "minimum_offer_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "sms_url"
    t.text     "sms_user_name"
    t.text     "sms_pass"
    t.text     "sms_sender_id"
    t.text     "about_us"
    t.text     "our_team"
    t.text     "how_works"
    t.text     "privacy"
    t.text     "press"
    t.text     "blog"
    t.text     "face_book"
    t.text     "twitter"
    t.text     "linked_in"
    t.text     "faq"
    t.text     "jobs"
    t.text     "terms"
    t.integer  "daily_deal_sms"
    t.integer  "item_sms_interval"
    t.string   "home_page_url"
    t.string   "us_currency_symbol"
    t.string   "us_buysell_transaction_fee"
    t.string   "ads_country"
    t.text     "us_national_ads"
    t.string   "how_to_play_url"
    t.string   "default_ad_url"
    t.integer  "ad_user_percent"
    t.integer  "ad_user_referee_percent"
    t.float    "mobile_min_recharge",        :default => 0.0
    t.string   "how_works_1"
    t.string   "how_works_2"
    t.string   "how_works_3"
    t.string   "paid_ad_home"
    t.string   "paid_ad_page"
    t.string   "tv_video_home"
    t.string   "how_works_4"
    t.string   "how_works_5"
    t.string   "how_works_6"
  end

  create_table "merchant_books_libraries", :force => true do |t|
    t.integer  "merchant_id"
    t.integer  "user_id"
    t.string   "book_ISBN"
    t.string   "book_title"
    t.string   "book_description"
    t.string   "book_taged_categs"
    t.string   "book_author"
    t.string   "book_subject"
    t.string   "book_pulisher"
    t.datetime "book_published_date"
    t.string   "book_cover_URL"
    t.integer  "quantity"
    t.float    "book_MRP"
    t.float    "book_sale_price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merchant_offers", :force => true do |t|
    t.integer  "user_request_id"
    t.integer  "user_id"
    t.integer  "merchant_id"
    t.float    "offer_price"
    t.datetime "offered_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "item_info"
    t.integer  "minimum_offer_time"
    t.datetime "offer_expired"
    t.string   "shipping_charge"
    t.string   "mode_of_shipping"
    t.float    "total_price"
    t.string   "company_name"
    t.string   "contact_person"
    t.string   "contact_number"
    t.boolean  "sms_flag"
    t.boolean  "reject_offer"
    t.decimal  "fee_agreed",                                   :precision => 10, :scale => 2, :default => 0.0
    t.string   "buysell_img_file_name"
    t.string   "buysell__img_content_type"
    t.integer  "buysell_img_file_size"
    t.datetime "buysell_img_updated_at"
    t.string   "flight_leaving_depart_city"
    t.string   "flight_leaving_depart_state"
    t.string   "flight_leaving_depart_country"
    t.string   "flight_leaving_arrival_city"
    t.string   "flight_leaving_arrival_state"
    t.string   "flight_leaving_arrival_country"
    t.datetime "flight_leaving_departure"
    t.datetime "flight_leaving_arrival"
    t.integer  "flight_leaving_stops",                                                        :default => 0
    t.string   "flight_leaving_airline"
    t.string   "flight_leaving_class"
    t.string   "flight_leaving_otherslot"
    t.string   "flight_return_depart_city"
    t.string   "flight_return_depart_state"
    t.string   "flight_return_depart_country"
    t.string   "flight_return_arrival_city"
    t.string   "flight_return_arrival_state"
    t.string   "flight_return_arrival_country"
    t.datetime "flight_returning_departure"
    t.datetime "flight_returning_arrival"
    t.integer  "flight_returning_stops",                                                      :default => 0
    t.string   "flight_returning_airline"
    t.string   "flight_returning_class"
    t.string   "flight_returning_otherslot"
    t.integer  "is_template",                     :limit => 1,                                :default => 0
    t.float    "tax_percent",                                                                 :default => 0.0
    t.string   "isbn_code"
    t.string   "publisher"
    t.string   "condition"
    t.float    "mrp"
    t.integer  "library_id"
    t.integer  "is_cust_support_esclation",       :limit => 1,                                :default => 0
    t.integer  "is_extended_for",                 :limit => 1,                                :default => 0
    t.string   "offer_img_root",                                                              :default => "http://mydeals247.com"
    t.integer  "tenure_term"
    t.integer  "interest_rate"
    t.integer  "warranty"
    t.string   "warranty_tenure"
    t.integer  "cab_max_km"
    t.string   "currency_code"
    t.float    "exchange_rate",                                                               :default => 65.0388
    t.float    "total_price_inr"
    t.float    "total_price_usd"
    t.string   "onbehalf_hotel_name"
    t.text     "onbehalf_hotel_addr"
    t.string   "onbehalf_hotel_contact"
    t.string   "flight_leaving_depart_latilong"
    t.string   "flight_leaving_arrival_latilong"
    t.string   "flight_return_depart_latilong"
    t.string   "flight_return_arrival_latilong"
  end

  create_table "merchants", :force => true do |t|
    t.integer  "user_id"
    t.string   "website_url"
    t.string   "contact_person"
    t.integer  "account_no"
    t.string   "bank_name"
    t.string   "branch"
    t.string   "checking"
    t.string   "routing"
    t.string   "swift_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "business_name"
    t.text     "contact_detail"
    t.string   "contact_no"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "status",                                 :default => "pending"
    t.string   "id_proof_doc"
    t.integer  "requested_category"
    t.string   "merchant_img_file_name"
    t.string   "merchant_img_content_type"
    t.integer  "merchant_img_file_size"
    t.datetime "merchant_img_updated_at"
    t.string   "merchant_logo_name"
    t.string   "logo_img_root",                          :default => "http://mydeals247.com"
    t.integer  "is_B2B",                    :limit => 1, :default => 0
    t.string   "latilong"
  end

  create_table "my_deals_slider_images", :force => true do |t|
    t.string   "img_url"
    t.string   "img_post"
    t.string   "img_description"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "offer_amenities", :force => true do |t|
    t.integer  "merchant_offer_id"
    t.integer  "amenity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchase_deal_configurations", :force => true do |t|
    t.integer  "purchase_deal_id"
    t.string   "config_param_name"
    t.string   "config_param_value"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchase_deals", :force => true do |t|
    t.integer  "user_id"
    t.integer  "deal_id"
    t.integer  "bought_deal_id"
    t.string   "security_code"
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity"
    t.string   "name"
    t.string   "email"
    t.boolean  "seller_payment_status"
    t.boolean  "email_sent"
    t.string   "mobile"
    t.text     "shipping_addr"
    t.text     "billing_addr"
    t.float    "vat",                   :default => 0.0
    t.string   "sent_voucher_root",     :default => "http://mydeals247.com"
    t.string   "uuid"
  end

  create_table "qualification_levels", :force => true do |t|
    t.integer  "is_blocked",  :limit => 1, :default => 0
    t.string   "name"
    t.integer  "level"
    t.string   "color_code"
    t.string   "icon"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by",               :default => 0
    t.integer  "approved_by",              :default => 0
  end

  create_table "quantitative_discounts", :force => true do |t|
    t.integer  "quantity"
    t.float    "discount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "deal_id"
  end

  create_table "registerform", :force => true do |t|
    t.string  "first_name",                :null => false
    t.string  "last_name",                 :null => false
    t.string  "email",                     :null => false
    t.string  "password",                  :null => false
    t.integer "mobile",     :limit => 8,   :null => false
    t.string  "gender",     :limit => 10,  :null => false
    t.string  "city",       :limit => 200, :null => false
    t.string  "emp_status", :limit => 200, :null => false
    t.integer "zipcode",    :limit => 8,   :null => false
    t.date    "dob",                       :null => false
  end

  create_table "request_amenities", :force => true do |t|
    t.integer  "user_request_id"
    t.integer  "amenity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedulers", :force => true do |t|
    t.datetime "daily_deals_sms_date"
    t.datetime "item_interval_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seller_interests", :force => true do |t|
    t.integer  "user_id"
    t.integer  "buysell_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",              :limit => 1,                                :default => 0
    t.decimal  "commission_percent",               :precision => 10, :scale => 2, :default => 0.0
  end

  create_table "seller_prefs", :force => true do |t|
    t.integer  "user_id"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "latilong"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id",                       :null => false
    t.text     "data",       :limit => 2147483647
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

 create_table "user_active_sessions", :force => true do |t|
    t.integer  "user_id"
    t.string   "session_id"
    t.string   "ip_address"
    t.string   "agent_browser"
    t.string   "agent_os"
    t.integer  "is_active",     :limit => 1, :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  create_table "shipping_addresses", :force => true do |t|
    t.integer  "trn_id"
    t.string   "name"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zip"
    t.string   "mobile"
    t.string   "fax"
    t.text     "billing_addr"
    t.text     "shipping_addr"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "latilong"
  end

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "simple_captcha_data", ["key"], :name => "idx_key"

  create_table "sms_alerts", :force => true do |t|
    t.integer  "user_request_id"
    t.string   "category_name"
    t.string   "item_info"
    t.integer  "expected_total"
    t.integer  "successfull_sms"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sold_deal_commisions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "deal_id"
    t.integer  "bought_deal_id"
    t.integer  "commisioned_by_user_id"
    t.string   "commision_type"
    t.float    "commision_percent"
    t.float    "commision_amount"
    t.integer  "commision_distributed_with"
    t.string   "payment_status"
    t.string   "transaction_remark"
    t.float    "paid_amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "currency_code"
    t.float    "exchange_rate",              :default => 65.0388
  end

  create_table "third_parties", :force => true do |t|
    t.string   "name"
    t.string   "secret_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_acls", :force => true do |t|
    t.string "acl_name"
    t.string "acl_code"
  end

  create_table "user_ad_credit_debits", :force => true do |t|
    t.integer  "coupon_id"
    t.integer  "user_id"
    t.string   "trn_type"
    t.float    "amount"
    t.string   "particulars"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "debit_particular"
    t.string   "credit_type"
    t.string   "currency_code"
    t.float    "exchange_rate",    :default => 65.0388
  end

  create_table "user_ad_referers", :force => true do |t|
    t.integer  "user_id"
    t.string   "email_id"
    t.string   "name"
    t.integer  "is_email_sent",    :limit => 1, :default => 0
    t.integer  "is_reminder_sent", :limit => 1, :default => 0
    t.integer  "is_registered",    :limit => 1, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_ad_transactions", :force => true do |t|
    t.integer  "coupon_id"
    t.integer  "user_id"
    t.integer  "is_qualified",        :limit => 1, :default => 0
    t.float    "amt_earned"
    t.string   "amt_earned_currency"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "access_ip_address"
    t.string   "access_location"
    t.string   "currency_code"
    t.float    "exchange_rate",                    :default => 65.0388
  end

  create_table "user_alerts", :force => true do |t|
    t.integer  "user_id"
    t.string   "alert_title"
    t.string   "alert_message"
    t.string   "alert_url"
    t.string   "alert_type"
    t.string   "alert_id"
    t.integer  "read_status",   :limit => 1, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_assigned_acls", :force => true do |t|
    t.integer "user_id"
    t.integer "acl_id"
  end

  create_table "user_comments", :force => true do |t|
    t.string   "txn_type"
    t.integer  "deal_id"
    t.integer  "user_request_id"
    t.integer  "user_id"
    t.integer  "logged_by"
    t.string   "comment_type"
    t.string   "priority"
    t.text     "comment_message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_interaction_by_partners", :force => true do |t|
    t.integer  "partner_id"
    t.integer  "visitor_id"
    t.string   "session_id"
    t.integer  "action_id"
    t.string   "action_type"
    t.string   "action_txt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "action_sub_type"
  end

  create_table "user_interests", :force => true do |t|
    t.integer  "user_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_messages", :force => true do |t|
    t.integer  "user_id"
    t.string   "msg_subject"
    t.text     "msg_body"
    t.string   "msg_url"
    t.string   "msg_object_type"
    t.string   "msg_type"
    t.string   "msg_object_id"
    t.integer  "read_status",          :limit => 1, :default => 0
    t.integer  "has_attachment",       :limit => 1, :default => 0
    t.string   "attachment_file_type"
    t.string   "attachment_file_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_mydeals_ad_codes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "height"
    t.integer  "width"
    t.string   "logo_type"
    t.text     "ad_src"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_prefs", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "latilong"
  end

  create_table "user_recharge_requests", :force => true do |t|
    t.integer  "user_id"
    t.string   "plan_type"
    t.string   "mobile_no"
    t.string   "mobile_operator"
    t.float    "recharge_amt"
    t.string   "prefered_plan"
    t.string   "customer_id"
    t.text     "user_remark"
    t.text     "admin_remark"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ip_address"
    t.string   "currency_code"
    t.float    "exchange_rate",   :default => 65.0388
  end

  create_table "user_requests", :force => true do |t|
    t.integer  "user_id"
    t.integer  "buysell_category_id"
    t.float    "price"
    t.string   "zipcode"
    t.string   "radius"
    t.string   "descision_factor"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_id"
    t.string   "item_info"
    t.string   "item_condition"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.integer  "number_of_items"
    t.string   "total_price"
    t.datetime "pick_up_date"
    t.datetime "drop_off_date"
    t.datetime "check_in_date"
    t.datetime "check_out_date"
    t.integer  "no_of_rooms"
    t.integer  "adult"
    t.integer  "children"
    t.integer  "no_of_bed_rooms"
    t.float    "sq_feet"
    t.datetime "from_date"
    t.datetime "to_date"
    t.string   "item_code"
    t.text     "item_spec"
    t.boolean  "status"
    t.boolean  "expiry_info"
    t.boolean  "seller_expiry_info"
    t.string   "locality"
    t.string   "flight_type"
    t.string   "travel_type"
    t.string   "flight_depart_city"
    t.string   "flight_depart_state"
    t.string   "flight_depart_country"
    t.string   "flight_arrival_city"
    t.string   "flight_arrival_state"
    t.string   "flight_arrival_country"
    t.integer  "flight_adults",                          :default => 0
    t.integer  "flight_children",                        :default => 0
    t.integer  "flight_infants",                         :default => 0
    t.integer  "flight_seniors",                         :default => 0
    t.datetime "flight_orgin_datetime"
    t.datetime "flight_return_datetime"
    t.integer  "flight_no_stops",                        :default => 0
    t.string   "flight_preferred_airlines"
    t.string   "flight_preferred_class"
    t.string   "flight_preferred_timeslot"
    t.float    "grand_total"
    t.string   "book_cover_url"
    t.string   "book_authors"
    t.string   "book_publisher"
    t.integer  "is_extended",               :limit => 1, :default => 0
    t.integer  "is_cust_support_esclation", :limit => 1, :default => 0
    t.string   "color_pref"
    t.string   "make_year"
    t.string   "contact_pref"
    t.integer  "item_catalog_id"
    t.integer  "tenure_term"
    t.integer  "interest_rate"
    t.integer  "is_B2B",                    :limit => 1, :default => 0
    t.text     "cab_starting_point"
    t.text     "cab_dropping_point"
    t.string   "landmark"
    t.datetime "cab_start_datetime"
    t.integer  "cab_bags"
    t.string   "type_of_vehicle"
    t.string   "ac_non_ac"
    t.integer  "cab_no_of_days"
    t.text     "cab_trip_details"
    t.datetime "cab_booking_time"
    t.datetime "cab_end_datetime"
    t.string   "crm_opportinuty_id"
    t.string   "crm_revenue_id"
    t.string   "currency_code"
    t.float    "exchange_rate",                          :default => 65.0388
    t.string   "latilong"
    t.string   "flight_depart_latilong"
    t.string   "flight_arrival_latilong"
  end

  create_table "user_upload_logs", :force => true do |t|
    t.string   "file_name"
    t.string   "log_file_name"
    t.integer  "uploaded_by"
    t.integer  "status",        :limit => 1, :default => 0
    t.integer  "no_of_record"
    t.string   "no_of_attempt"
    t.integer  "emailed",       :limit => 1, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.string   "fname"
    t.string   "lname"
    t.string   "display_name"
    t.string   "email"
    t.string   "user_type"
    t.string   "user_status"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "facebook_uid"
    t.string   "sub_type"
    t.boolean  "pass_flag",                                   :default => true
    t.integer  "fb_id"
    t.string   "email_hash"
    t.integer  "login_count",                                 :default => 0
    t.string   "mobile_verification_code"
    t.integer  "mobile_verified",                :limit => 1, :default => 0
    t.string   "partner_uuid"
    t.string   "partner_parent_uuid"
    t.float    "partner_direct_percent"
    t.float    "partner_direct_manager_percent"
    t.float    "partner_rest_percent"
    t.string   "bank_account_no"
    t.string   "bank_name"
    t.string   "bank_branch"
    t.string   "bank_ifsc_code"
    t.integer  "is_through_csv",                 :limit => 1, :default => 0
    t.integer  "is_email_sent",                  :limit => 1, :default => 1
    t.integer  "referred_by"
    t.float    "ad_credit_payout",                            :default => 0.0
    t.string   "ad_credit_currency"
    t.datetime "birthday"
    t.string   "gender"
    t.string   "employment_status"
    t.datetime "last_accessed_at",                            :default => '2013-01-25 03:33:12'
    t.integer  "notify_only_my_loc",             :limit => 1, :default => 0
    t.float    "partner_ad_commision",                        :default => 0.0
    t.datetime "partner_ad_commision_from"
    t.datetime "partner_ad_commision_to"
    t.integer  "is_B2B",                         :limit => 1, :default => 0
    t.integer  "is_travel_agent",                :limit => 1, :default => 0
    t.string   "third_party_user_id"
    t.string   "third_party_creator_id"
    t.string   "lead_preference"
    t.string   "country_code"
    t.string   "user_entity",                                 :default => "buysell"
    t.string   "user_img_file_name"
    t.string   "user_img_content_type"
    t.integer  "user_img_file_size"
    t.datetime "user_img_updated_at"
    t.datetime "mobile_verf_date",                            :default => '2013-12-19 17:20:13'
    t.integer  "mobile_verf_re",                 :limit => 1, :default => 0
    t.integer  "is_img_complete",                :limit => 1, :default => 0
    t.string   "user_img_root",                               :default => "http://mydeals247.com"
  end

  create_table "vouchers", :force => true do |t|
    t.string   "vcode"
    t.boolean  "status"
    t.integer  "deal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
