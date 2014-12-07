module ApplicationHelper
  def get_url
    global_url = request.protocol().to_s + request.host.to_s    
    if !request.domain || request.domain == "localhost"
      global_url += ":" + request.port.to_s
    end
    return global_url
  end
  
  def facebook_path
    '/facebooks/facebook_success'
  end
def city_latilong(city)
    latilong_str = ""
    if !city.blank?
      city = city.gsub("\\", "")
      city = city.gsub("'", "")
      addrsql = "SELECT `latilong` FROM `addresses` WHERE `city` = '#{city}' LIMIT 0, 1"
      city = city.gsub(" ", "%20")
    begin
        address = Address.find_by_sql(addrsql)
        if address.size > 0
          latilong_str = address[0].latilong unless latilong_str.nil? && latilong_str == "||"
          Rails.logger.warn "Got from inhouse address itself... #{latilong_str}" 
        end
        if latilong_str == "" || latilong_str == "||" || latilong_str.nil? || latilong_str.blank?
          Rails.logger.warn "#{latilong_str} is still not valid"
          latilong_URL = "http://maps.google.com/maps/api/geocode/json?address=#{city}&sensor=false"
          Rails.logger.warn latilong_URL
          src = Net::HTTP.get(URI.parse(latilong_URL))
          parsed_json = ActiveSupport::JSON.decode(src)
          Rails.logger.warn parsed_json['status']
          if parsed_json['status'] == "OVER_QUERY_LIMIT"
              Emailer.threshold_geoCodeAPI().deliver
              latilong_str = ""
              Rails.logger.warn "OVER Query Result"
              Rails.logger.warn latilong_str      
          elsif parsed_json['status'] == "ZERO_RESULTS"
              latilong_str = ""
              Rails.logger.warn "Zero Result"
              Rails.logger.warn latilong_str
          elsif parsed_json['status'] == "OK"  
            latitude = parsed_json['results'][0]['geometry']['location']['lat'] unless parsed_json['results'].blank?
            longitude = parsed_json['results'][0]['geometry']['location']['lng'] unless parsed_json['results'].blank?
            latilong_str =  latitude.to_s+"||"+longitude.to_s
            Rails.logger.warn "got langitude"
            Rails.logger.warn  latilong_str
          else
            latilong_str = ""
            Rails.logger.warn "none condition"
            Rails.logger.warn latilong_str  
          end
        end
      rescue Exception => exc
        Rails.logger.warn "Error while getting latilong for city "+city+". Error Message::  "+exc.message
        latilong_str = ""
      end 
    else
      latilong_str = ""
    end
    return latilong_str
  end
  def offers_count
    offer_count = "0"
    unless session[:user].nil?
      user_requests = session[:user].user_requests.where(["end_date >= ? and status = ?", Time.now.in_time_zone.utc().strftime("%Y-%m-%d %H:%M:%S"), false])
      req_ids = ""
      user_requests.each do |ureq|
        req_ids == "" ? req_ids << ureq.id.to_s : req_ids << ", " << ureq.id.to_s
      end
      
      if req_ids != ""
        offer_count = MerchantOffer.count(:conditions => "user_request_id in (#{req_ids}) and offer_expired >= '#{Time.now.in_time_zone.utc().strftime("%Y-%m-%d %H:%M:%S")}' and reject_offer = FALSE")
      end
    end
    return offer_count
  end
   def city_latilong(city)
    latilong_str = ""
    if !city.blank?
      city = city.gsub("\\", "")
      city = city.gsub("'", "")
      addrsql = "SELECT `latilong` FROM `addresses` WHERE `city` = '#{city}' LIMIT 0, 1"
      city = city.gsub(" ", "%20")
    begin
        address = Address.find_by_sql(addrsql)
        if address.size > 0
          latilong_str = address[0].latilong unless latilong_str.nil? && latilong_str == "||"
          Rails.logger.warn "Got from inhouse address itself... #{latilong_str}" 
        end
        if latilong_str == "" || latilong_str == "||" || latilong_str.nil? || latilong_str.blank?
          Rails.logger.warn "#{latilong_str} is still not valid"
          latilong_URL = "http://maps.google.com/maps/api/geocode/json?address=#{city}&sensor=false"
          Rails.logger.warn latilong_URL
          src = Net::HTTP.get(URI.parse(latilong_URL))
          parsed_json = ActiveSupport::JSON.decode(src)
          Rails.logger.warn parsed_json['status']
          if parsed_json['status'] == "OVER_QUERY_LIMIT"
              Emailer.threshold_geoCodeAPI().deliver
              latilong_str = ""
              Rails.logger.warn "OVER Query Result"
              Rails.logger.warn latilong_str      
          elsif parsed_json['status'] == "ZERO_RESULTS"
              latilong_str = ""
              Rails.logger.warn "Zero Result"
              Rails.logger.warn latilong_str
          elsif parsed_json['status'] == "OK"  
            latitude = parsed_json['results'][0]['geometry']['location']['lat'] unless parsed_json['results'].blank?
            longitude = parsed_json['results'][0]['geometry']['location']['lng'] unless parsed_json['results'].blank?
            latilong_str =  latitude.to_s+"||"+longitude.to_s
            Rails.logger.warn "got langitude"
            Rails.logger.warn  latilong_str
          else
            latilong_str = ""
            Rails.logger.warn "none condition"
            Rails.logger.warn latilong_str  
          end
        end
      rescue Exception => exc
        Rails.logger.warn "Error while getting latilong for city "+city+". Error Message::  "+exc.message
        latilong_str = ""
      end 
    else
      latilong_str = ""
    end
    return latilong_str
  end
  def deals_count
    deal_count = "0"
    if !session[:user].nil? && session[:user].user_type != "admin" && session[:user].sub_type != "seller"
      user_interests = session[:user].user_interests.all :select => "category_id"
      category_ids = ""
      user_interests.each do |user_interest|
        category_ids == "" ? category_ids << user_interest.category_id.to_s : category_ids << "," << user_interest.category_id.to_s 
      end
      merch_id = session[:user].merchant.id unless session[:user].merchant.nil?
      if session[:user].sub_type == "franchisee" || session[:user].sub_type == "partner" || session[:user].sub_type == "iPartner"
        deals = Deal.with_out_merchant(merch_id).with_location(session[:user].user_pref.latilong).with_offline("1").with_bought_count().with_date(Time.now.in_time_zone.utc().strftime("%Y-%m-%d %H:%M:%S")).with_pub("1").with_category(category_ids) unless category_ids.blank?
      else
        deals = Deal.with_out_merchant(merch_id).with_location(session[:user].user_pref.latilong).with_offline("0").with_bought_count().with_date(Time.now.in_time_zone.utc().strftime("%Y-%m-%d %H:%M:%S")).with_pub("1").with_category(category_ids) unless category_ids.blank?
      end   
      
      deal_count = deals.count unless deals.blank?
    end
    return deal_count
  end
  
  def get_cur_userAd_payout
    user = User.find(session[:user].id)
    #referals_payout =  User.where("referred_by = #{user.id}").sum(:ad_credit_payout)
    #cur_user_credit = (referals_payout * session[:master].ad_user_referee_percent)/100
    #cur_user_total_pay =  user.ad_credit_payout + cur_user_credit
    return user.ad_credit_payout
  end
  def get_cur_user_msg
    count = UserMessage.where("user_id = #{session[:user].id} and read_status = false").count
    return count
  end
  def request_count
    req_count = ""
    unless session[:user].nil?
      seller_interests = session[:user].seller_interests.all :select => "buysell_category_id", :conditions => ["buysell_category_id != ?", 58]
      category_ids = "0"
      seller_interests.each do |seller_interest|
          category_ids == "" ? category_ids << seller_interest.buysell_category_id.to_s : category_ids << "," << seller_interest.buysell_category_id.to_s
      end
      user_requests = UserRequest.with_active.without_curr_user(session[:user].id).with_category(category_ids).with_city(session[:user].user_pref.city.force_encoding('UTF-8'))
      req_count = user_requests.count
    
      library_objs = MerchantBooksLibrary.where("user_id = #{session[:user].id}")
        isbn_nos = "0"
        library_objs.each do |library_obj|
          isbn_nos == "" ? isbn_nos << library_obj.book_ISBN : isbn_nos << "," << library_obj.book_ISBN 
      end
      
    seller_interests = SellerInterest.joins(:buysell_category).all(:conditions => ["user_id = ?", session[:user].id])
    categ_ids = SellerInterest.get_all_category_ids(seller_interests)
    @merchant = Merchant.first(:conditions => ["user_id = ?", session[:user].id])
    @merchant_offered_rqsts = UserRequest.joins(:merchant_offers).all(:conditions => ["merchant_offers.merchant_id = ? and city != ? and user_requests.end_date > ? and user_requests.status = ? and user_requests.buysell_category_id != ?", @merchant.id,session[:user].user_pref.city.force_encoding('UTF-8'),Time.now.in_time_zone.utc().strftime("%Y-%m-%d %H:%M:%S"), false, 58])
    @bk_requests = UserRequest.without_curr_user(session[:user].id).with_active.with_ISBN(isbn_nos).order("created_at DESC")
    req_count = req_count + @merchant_offered_rqsts.count + @bk_requests.count
    end
    return req_count
  end

  def get_my_chain(user)
    managers = Array.new
    if user.sub_type == 'partner'
    still_has_manager = true
    prev_manager = user 
      while still_has_manager
        manager = User.first(:conditions => "partner_uuid = '#{prev_manager.partner_parent_uuid}'")
        prev_manager = manager
        if !manager.nil?
          managers.push manager
          still_has_manager = true
        else 
          still_has_manager = false
        end
      end
    end
    return managers  
  end
  def get_advitisor_balance(coupon)
    total_qualified = UserAdTransaction.where("coupon_id = #{coupon.id} and is_qualified = true").count
    Rails.logger.warn total_qualified
    Rails.logger.warn coupon.per_quiz_cost
    total_money_bournt = total_qualified * coupon.per_quiz_cost
    Rails.logger.warn total_money_bournt
    available_balance = coupon.user_price - total_money_bournt
    Rails.logger.warn available_balance
    return price_format(available_balance)  
  end
  def role_type(user)
    return "Admin" if user.sub_type == "admin"
    return "Deals Approver" if user.sub_type == "deal"
    return "Seller Approver" if user.sub_type == "Merchant"
    return "Ads Approver" if user.sub_type == "Coupon"
    return "Merchant" if user.sub_type == "seller"
    return "Registered user" if user.sub_type.nil?
    return "Employer" if user.user_entity.downcase == "jobs"
    return "Job Seeker" if !user.job_profile.nil?
    return "Buyer" if user.sub_type.downcase == "buyer"
    return "Buyer And Seller" if user.sub_type.downcase == "buysell"
    return "Sales Partner" if user.sub_type.downcase == "partner"
    return "Franchisee Partner" if user.sub_type.downcase == "franchisee"
    return "Interner Partner" if user.sub_type.downcase == "ipartner"
  end

  def user_type(type)
    return "Admin" if type == "admin"
    return "Deals Approver" if type == "deal"
    return "Seller" if type == "Merchant"
    return "Buyer" if type == "Buyer"
    return "Merchant" if type == "seller"
    return "User" if type == "user"
    return "Sales Partner" if type == "partner"
    return "Franchisee Partner" if type == "franchisee"
    return "Interner Partner" if type == "iPartner"
    
  end
  
  def welcom_head
    user = session[:user]
    if !user.nil? && user.user_type != "admin"
      return "(Seller)" if user.sub_type == "buysell"
      return "(Buyer)" if user.sub_type == "buyer"
      return "(Seller)" if user.sub_type == "seller"
    else
      return
    end
  end
  
  def users_heading
    user = session[:user]
    return "Sellers List" if user.sub_type == "Merchant"
    return "Buyers List" if user.sub_type == "Buyer"
    return "Users List"
  end
  
  def price_format(price)
    return "%.2f" % price
  end
  def year_format(year)
    return "%.1f" % year
  end
  def ad_credit_text(userId)
    debit =  UserAdCreditDebit.sum(:amount, :conditions => ['user_id = ? and trn_type = ?', userId, 'Debit'])  
    credit = UserAdCreditDebit.sum(:amount, :conditions => ['user_id = ? and trn_type = ?', userId, 'Credit'])   
    if credit.to_f > 0
      return "<b>Rs. "+price_format(debit).to_s+"</b> out of <b>Rs. "+price_format(credit).to_s+ "</b> Paid"
    else
      return "Rs. 0"  
    end
  end
  def has_access(userId, label)
    @acl = UserAcl.first(:conditions => "acl_name = '#{label}'")
    has_permission = false
    if !@acl.blank? || !@acl.nil?
      @assigned_acl = UserAssignedAcl.first(:conditions => "user_id = #{userId} and acl_id = #{@acl.id}")
      if !@assigned_acl.blank? || !@assigned_acl.nil?
        has_permission = true
      else
        has_permission = false
     end
    end
    return has_permission
  end 
  def get_category_ids(user_interests)
    category_ids = ""
    user_interests.each do |user_interest|
      category_ids == "" ? category_ids << user_interest.category_id.to_s : category_ids << "," << user_interest.category_id.to_s 
    end
    return category_ids
  end
  def get_book_distributor()
    user_ids = "-1"
    destributer_category = BuysellCategory.first(:conditions => "name = 'I am a book distributor / whole-seller'")
    users_sql = "select distinct u.* from users as u, seller_interests si where u.id = si.user_id and si.buysell_category_id =  #{destributer_category.id} and u.last_accessed_at >= DATE_SUB(SYSDATE(), INTERVAL 30 DAY)"
    users_bk_destributers = User.find_by_sql(users_sql)
    users_bk_destributers.each do |users|
      user_ids == "" ? user_ids << users.id.to_s : user_ids << "," << users.id.to_s 
    end
    return user_ids
  end
  def is_book_distributor()
    destributer_category = BuysellCategory.first(:conditions => "name = 'I am a book distributor / whole-seller'")
    si = SellerInterest.first(:conditions => "buysell_category_id = #{destributer_category.id} and user_id = #{session[:user].id}")
    if si.nil? || si.blank?
      return false
    else
      return true  
    end
  end
  def lowest_offer_price(user_req)
    Rails.logger.warn "getting the lowest offer price"
    offer_price = ""
    if $currency_type == "$"
      Rails.logger.warn "current currency is doller"
      offer = user_req.merchant_offers.first(:conditions => "reject_offer = false", :order => "total_price_usd ASC")
      offer_price = offer.total_price_usd unless offer.nil?
      Rails.logger.warn "GOT total price in USD"
      Rails.logger.warn offer_price
      if offer_price.blank? || offer_price.nil?
        Rails.logger.warn "offer price USD is blank, hence getting the offer price" 
        offer = user_req.merchant_offers.first(:conditions => "reject_offer = false", :order => "offer_price ASC")
        offer_price = offer.offer_price unless offer.nil?
        Rails.logger.warn "got the actual offer price..."
        Rails.logger.warn offer_price
      end
    elsif $currency_type == "Rs"
      Rails.logger.warn "current currency is rupee"
      offer = user_req.merchant_offers.first(:conditions => "reject_offer = false", :order => "total_price_inr ASC")
      offer_price = offer.total_price_inr unless offer.nil?
      Rails.logger.warn "GOT total price in INR"
      Rails.logger.warn offer_price
      if offer_price.blank? || offer_price.nil?
        Rails.logger.warn "offer price in INR is blank, hence getting the offer price.." 
        offer = user_req.merchant_offers.first(:conditions => "reject_offer = false", :order => "offer_price ASC")
        offer_price = offer.offer_price unless offer.nil?
        Rails.logger.warn "GOT the actual offer price"
        Rails.logger.warn offer_price
      end
    end  
    if !offer_price.blank?
      offer_price = price_format(offer_price)
    end
    return offer_price
  end
  def lowest_offer_by(user_req)
    offer = user_req.merchant_offers.first(:conditions => "reject_offer = false", :order => "offer_price ASC")
    @seller = nil
    @seller = offer.merchant.user unless offer.nil?
    return @seller
  end
  
  def convert_rupee_to_doller(rupee_amt, exchange_rate)
      rupee_to_doller = "%6.02f" % (rupee_amt.to_f/exchange_rate.to_f)
      Rails.logger.warn "Rupee to Doller = :"
      Rails.logger.warn rupee_to_doller
      return rupee_to_doller
  end
  
  def convert_doller_to_rupee(doller_amt, exchange_rate)
      doller_to_rupee =  "%6.02f" % (doller_amt.to_f * exchange_rate.to_f)
      Rails.logger.warn "Doller to Rupee :"
      Rails.logger.warn doller_to_rupee
      return doller_to_rupee
  end
end
