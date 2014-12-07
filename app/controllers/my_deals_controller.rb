class MyDealsController < ApplicationController
  def index
    respond_to do |format|
      format.html {render :layout => false}
    end
  end

  def home
    respond_to do |format|
      format.html {render :layout => false}
    end
  end
  def employee_home
    respond_to do |format|
      format.html {render :layout => false}
    end
  end
  
  def sellerhome
    user_email = params[:email]
    unless user_email.blank?
      url = "http://#{$api_host}/my_deals/main_usr_info.json?email=#{user_email}"
      Rails.logger.warn url
      uri = URI.parse(URI.encode(url.strip)) unless url.blank?
      Rails.logger.warn uri
      src = Net::HTTP.get(uri)
      Rails.logger.warn src
      parsed_json = ActiveSupport::JSON.decode(src)
      Rails.logger.warn "elect to get user type from JSON"
      success = parsed_json['success']
      Rails.logger.warn success
      Rails.logger.warn success == "true"
      if success
        Rails.logger.warn parsed_json['sub_type']
        session[:uType] = parsed_json['sub_type']
        Rails.logger.warn "user type from variable"
        Rails.logger.warn session[:uType]
      end
    end
    respond_to do |format|
      format.html {render :layout => false}
    end
  end
  
  def buyerhome
    user_email = params[:email]
    unless user_email.blank?
      url = "http://#{$api_host}/my_deals/main_usr_info.json?email=#{user_email}"
      Rails.logger.warn url
      uri = URI.parse(URI.encode(url.strip)) unless url.blank?
      Rails.logger.warn uri
      src = Net::HTTP.get(uri)
      Rails.logger.warn src

      parsed_json = ActiveSupport::JSON.decode(src)
      Rails.logger.warn "elect to get user type from JSON"
      success = parsed_json['success']
      if success == "true"
        Rails.logger.warn parsed_json['sub_type']
        session[:uType] = parsed_json['sub_type']
        Rails.logger.warn "user type from variable"
        Rails.logger.warn session[:uType]
      end
    end
    respond_to do |format|
      format.html {render :layout => false}
    end
  end
 def signin
   link_to_forward = params[:fwdlink]
   if !link_to_forward.blank?
     session[:link_to_forward] = link_to_forward
   end
   respond_to do |format|
      format.html
   end
 end 
 def signin_facebook
    Rails.logger.warn "********* from signin facebook ******************"
    Rails.logger.warn request.session_options[:id]
    Rails.logger.warn http_agent = request.env['HTTP_USER_AGENT'].downcase
    Rails.logger.warn remote_ip = request.remote_ip
    begin
      Rails.logger.warn "1"
      @user = User.find_by_email(params[:id]) unless params[:id].blank?
      @uas = UserActiveSession.first(:conditions => ["user_id = ? and created_at > ?", @user.id, (Time.now - 30.minutes).in_time_zone.utc().strftime("%Y-%m-%d %H:%M:%S")]) unless @user.nil?
      respond_to do |format|
        if !@user.nil?
          if @uas.nil?
            Rails.logger.warn "uas is nil"
            @user.user_active_sessions.destroy_all unless @user.user_active_sessions.nil?
            @uas = UserActiveSession.new
            @uas.user_id = @user.id
            Rails.logger.warn "Gone till here ..."
            @uas.session_id = request.session_options[:id]
            Rails.logger.warn "problem here"
            @uas.ip_address = request.remote_ip
            @uas.agent_browser = request.env['HTTP_USER_AGENT'].downcase
            @uas.save
            Rails.logger.warn "logged in here"
          else
            if @uas.agent_browser != http_agent
              format.json { render :json => '{"success":false, "msg":"You are already logged in other browser/device, Please logout and log-in again."}' }
            end
          end
          if @user.user_status == "active"
            @user.update_attribute :login_count, @user.login_count.to_i + 1
            @user.update_attribute :last_accessed_at, Time.now
            pwd = generate8
            encoded_str = ActiveSupport::Base64.encode64("#{@user.email}:#{pwd}")
            @user.update_attribute :password, Digest::SHA256.hexdigest(pwd)
            session[:uType] = @user.sub_type
            address = @user.address
            country_code = ""
            if !address.nil? && @user.country_code.nil?
              @user.update_attribute :country_code, "IN"
            elsif !@user.country_code.nil?
            country_code = @user.country_code
            else
              country_code = "US"
            end
            redirect_to :action => "buyerhome", :controller => "my_deals", :id => encoded_str
          else
            redirect_to :controller=>'my_deals', :action=>'index', :notice => "User account is inactive. Please send an email to support@mydeals247.com"
          end
        else
          redirect_to :controller=>'my_deals', :action=>'index', :notice => "Invalid User Name or Password."
        end
      end
    rescue Exception => exc
      message = exc.message
      message = "default error message" if exc.message.nil?
      Rails.logger.warn "Error Message: #{message}"
      Rails.logger.warn "Trace: #{exc.backtrace[0].split(":").last}"
      Rails.logger.warn "Full Trace: #{exc.backtrace}"
      exc.backtrace.each { |line| Rails.logger.warn line }
      redirect_to :controller=>'my_deals', :action=>'index', :notice => "The username that you requested for, does not exist.<br />Please try again with a valid username."
    end
  end    
  def loginservice
    user_id = params[:user]
    pwd = params[:password]
    session_id = request.session_options[:id]
    http_agent = request.env['HTTP_USER_AGENT'].downcase
    remote_ip = request.remote_ip
    Rails.logger.warn session_id
    Rails.logger.warn remote_ip
    Rails.logger.warn http_agent
    url = "http://#{$api_host}/my_deals/login_method.json?email=#{user_id}&password=#{pwd}&session_id=#{session_id}&http_agent=#{http_agent}&remote_ip=#{remote_ip}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    Rails.logger.warn "response is \n #{src}"
    parsed_json = ActiveSupport::JSON.decode(src)
    Rails.logger.warn "user type from JSON"
    Rails.logger.warn parsed_json['user_type']
    session[:uType] = parsed_json['user_type']
    Rails.logger.warn "user type from variable"
    Rails.logger.warn session[:uType]
    Rails.logger.warn "seesion post URL: #{$post_url}"
    success = parsed_json['success']
    if !$post_url.nil?
      url = $post_url
      auth_token = ActiveSupport::Base64.encode64("#{user_id}:#{pwd}")
      url = "#{url}#{auth_token}"
      uri = URI.parse(URI.encode(url.strip)) unless url.blank?
      Rails.logger.warn uri
      asrc = Net::HTTP.get(uri)
      Rails.logger.warn "posting request at login service ..."
      Rails.logger.warn asrc
      $post_url = nil
    end
    respond_to do |format|
      format.json { render :json => src }  
    end
  end

  def show_book_catelog
    auth = params[:auth_token]
    url = "http://#{$api_host}/users/list_library_books/get.json?auth_token=#{auth}"
    src = Net::HTTP.get(URI.parse(url))

    respond_to do |format|
      format.json { render :json => src }
    end
  end
  
   def forgot_pasword_email
    user = params[:user]
    url = "http://#{$api_host}/my_deals/forgot_pass/send_code.json?email=#{user}";
    src = Net::HTTP.get(URI.parse(url))
    respond_to do |format|
      format.json { render :json => src }
    end
  end
  
  def forgot_pasword_scode
    user = params[:user]
    code = params[:code]
    url = "http://#{$api_host}/my_deals/check_pass_code_verf/verify.json?email=#{user}&scode=#{code}";
    src = Net::HTTP.get(URI.parse(url))
    respond_to do |format|
      format.json { render :json => src }
    end
  end
  
  def forgot_pasword_change
    user = params[:user]
    pass = params[:pass]
    url = "http://#{$api_host}/my_deals/change_pass/reset.json?email=#{user}&pass=#{pass}";
    src = Net::HTTP.get(URI.parse(url))
    respond_to do |format|
      format.json { render :json => src }
    end
  end

  def list_amenities
    auth = params[:auth_token]
    url = "http://#{$api_host}/user_requests/list_amenities/get.json"
    src = Net::HTTP.get(URI.parse(url))

    respond_to do |format|
      format.json { render :json => src }
    end
  end
  def logoutservice
    auth_token = params[:auth_token]
    url = "http://#{$api_host}/my_deals/logout/signout.json?auth_token=#{auth_token}"
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    Rails.logger.warn src
    respond_to do |format|
      format.json { render :json => src }
    end
  end
  def book_search
    q = params[:q]
    cat = params[:cat]
    url = "http://#{$api_host}/my_deals/search_books/search/get.json?field=#{cat}&query=#{q}"
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)

    respond_to do |format|
      format.json { render :json => src }
    end
  end

  def rechargemob
    plantype = params[:plantype]
    prefplan = params[:prefplan]
    mobnum = params[:mobnum]
    cmobnum = params[:cmobnum]
    operator = params[:operator]
    amt = params[:amt]
    uid = params[:uid]
    auth_token = params[:auth]
    url = "http://#{$api_host}/coupons/recharge_mobile_request.json?user_recharge_request[plan_type]=#{plantype}&user_recharge_request[prefered_plan]=#{prefplan}&user_recharge_request[mobile_no]=#{mobnum}&user_recharge_request[mobile_operator]=#{operator}&user_recharge_request[recharge_amt]=#{amt}&user_recharge_request[user_id]=#{uid}&auth_token=#{auth_token}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)

    respond_to do |format|
      format.json { render :json => src }
    end
  end

  def item_catalog_result
    category = params[:category]
    scategory = params[:scategory]
    keyWord = params[:keyword]
    url = "http://#{$api_host}/my_deals/search_catalog_result/get.json?parent_id=#{category}&categ_id=#{scategory}&keyword=#{keyWord}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)

    respond_to do |format|
      format.json { render :json => src }
    end
  end

  def buyer_subcat
    category = params[:category]
    url = "http://#{$api_host}/buysell_categories/buysell_sub_category_json/get.json?categ_id=#{category}"
    src = Net::HTTP.get(URI.parse(url))

    respond_to do |format|
      format.json { render :json => src }
    end
  end

  def buysell_cat
    url = "http://#{$api_host}/buysell_categories/buysell_categories_json/get.json"
    src = Net::HTTP.get(URI.parse(url))

    respond_to do |format|
      format.json { render :json => src }
    end
  end
  def b2bbuysell_cat
    url = "http://#{$api_host}/buysell_categories/b2b_buysell_categories_json/get.json"
    src = Net::HTTP.get(URI.parse(url))
    respond_to do |format|
      format.json { render :json => src }
    end
  end
  def hotel_post
    category = params[:category]
    scategory = params[:scategory]
    city = params[:city]
    narea = params[:narea]
    info = params[:item_info]
    cidate = params[:cidate]
    codate = params[:codate]
    nroom = params[:nroom]
    adult = params[:adult]
    children = params[:children]
    bnight = params[:bnight]
    total = params[:total_budget_cost]
    dfactor = params[:dfactor]
    auth_token = params[:auth_token]
    aminity_params = ""
    if !params[:amenity_ids].nil?
      params[:amenity_ids].each do |ci|
        aminity_params += "&amenity_ids[]=#{ci}";
      end
    end
    url = "http://#{$api_host}/user_requests/create/new.json?categ_id=#{category}&user_request[buysell_category_id]=#{scategory}#{aminity_params}&user_request[city]=#{city}&show_user_request_price=#{narea}&user_request[item_info]=#{info}&checkin_date=#{cidate}&checkout_date=#{codate}&user_request[no_of_rooms]=#{nroom}&user_request[adult]=#{adult}&user_request[children]=#{children}&user_request[price]=#{bnight}&user_request[grand_total]=#{total}&user_request[descision_factor]=#{dfactor}&term_agreement_decision=on&auth_token=#{auth_token}"
    Rails.logger.warn url
    respond_to do |format|
      if auth_token.blank?
        $post_url = url
        Rails.logger.warn "setup post url to #{$post_url}"
        format.json { render :json => '{"success":false, "msg":"redirect", "id":"-1"}' }
      else
        uri = URI.parse(URI.encode(url.strip)) unless url.blank?
        Rails.logger.warn uri
        src = Net::HTTP.get(uri)
        format.json { render :json => src }
      end
    end
  end

  def post_apple_buy
    category = params[:cat_id]
    scategory = params[:scat_id]
    item_catalog_id = params[:catalog_id]
    item_info = params[:item_name]
    nitems = params[:number_of_items]
    price = params[:price]
    narea = params[:locality]
    city = params[:city]
    tcondition = params[:item_condition]
    spreference = params[:descision_factor]
    total = price_format(price.to_f * nitems.to_f)
    currency_code = "INR"
    auth = params[:auth_token]
    request_pref_type = params[:request_pref_type]
    item_spec = params[:item_spec] unless params[:item_spec].blank?
    spec_params = ""
    unless params[:item_spec].blank?
      spec_params = "&user_request[item_spec]=#{item_spec}"
    end
    Rails.logger.warn auth
    url = "http://#{$api_host}/user_requests/create/new.json?categ_id=#{category}&user_request[buysell_category_id]=#{scategory}#{spec_params}&user_request[item_catalog_id]=#{item_catalog_id}&user_request[item_info]=#{item_info}&user_request[number_of_items]=#{nitems}&user_request[price]=#{price}&user_request[locality]=#{narea}&user_request[city]=#{city}&user_request[item_condition]=#{tcondition}&user_request[descision_factor]=#{spreference}&user_request[grand_total]=#{total}&user_request[currency_code]=#{currency_code}&request_pref_type=#{request_pref_type}&auth_token=#{auth}"
    Rails.logger.warn url
    respond_to do |format|
      if auth.blank?
        $post_url = url
        Rails.logger.warn "setup post url to #{$post_url}"
        format.json { render :json => '{"success":false, "msg":"redirect", "id":"-1"}' }
      else
        uri = URI.parse(URI.encode(url.strip)) unless url.blank?
        Rails.logger.warn uri
        src = Net::HTTP.get(uri)
        format.json { render :json => src }
      end
    end
  end

   def post_education
    category = params[:cat_id]
    scategory = params[:scat_id]
    item_catalog_id = params[:catalog_id]
    item_type = params[:item_name]
     price = params[:price]
    city = params[:city]
    narea = params[:narea]
    item_info = item_type . near by . narea
    contact = params[:contact_pref]
    spreference = params[:descision_factor]
    currency_code = "INR"
    auth = params[:auth_token]
    Rails.logger.warn auth
    url = "http://#{$api_host}/user_requests/create/new.json?categ_id=#{category}&user_request[buysell_category_id]=#{scategory}&user_request[item_catalog_id]=#{item_catalog_id}&buysell_category_name=#{item_type}&user_request[city]=#{city}&user_request[item_info]=#{item_info}&user_request[price]=#{price}&user_request[contact_pref]=#{contact}&user_request[descision_factor]=#{spreference}&user_request[currency_code]=#{currency_code}&auth_token=#{auth}"
    Rails.logger.warn url
    respond_to do |format|
      if auth.blank?
        $post_url = url
        Rails.logger.warn "setup post url to #{$post_url}"
        format.json { render :json => '{"success":false, "msg":"redirect", "id":"-1"}' }
      else
        uri = URI.parse(URI.encode(url.strip)) unless url.blank?
        Rails.logger.warn uri
        src = Net::HTTP.get(uri)
        format.json { render :json => src }
      end
    end
  end
  
  def post_bank_loan
    category_name = "BankLoan"
    category = params[:cat_id]
    scategory = params[:scat_id]
    item_catalog_id = params[:catalog_id]
    item_type = params[:item_name]
    looking = params[:item_info]
    price = params[:grand_total]
    interest = params[:interest_rate]
    tenure_term = params[:tenure_term]
    city = params[:city]
    contact = params[:contact_pref]
    spreference = params[:descision_factor]
    currency_code = "INR"
    auth = params[:auth_token]
    Rails.logger.warn auth
    url = "http://#{$api_host}/user_requests/create/new.json?user_request[item_catalog_id]=#{item_type}&buysell_category_name=#{ category_name}&user_request[city]=#{city}&user_request[grand_total]=#{price}&user_request[interest_rate]=#{interest}&user_request[tenure_term]=#{tenure_term}&user_request[contact_pref]=#{contact}&user_request[descision_factor]=#{spreference}&user_request[currency_code]=#{currency_code}&auth_token=#{auth}"
    Rails.logger.warn url
    respond_to do |format|
      if auth.blank?
        $post_url = url
        Rails.logger.warn "setup post url to #{$post_url}"
        format.json { render :json => '{"success":false, "msg":"redirect", "id":"-1"}' }
      else
        uri = URI.parse(URI.encode(url.strip)) unless url.blank?
        Rails.logger.warn uri
        src = Net::HTTP.get(uri)
        format.json { render :json => src }
      end
    end
  end

  def book_catalog
    category = params[:category]
    scategory = params[:scategory]
    info = params[:item_info]
    specification = params[:item_spec]
    code = params[:isbn]
    author = params[:book_authors]
    publisher = params[:book_publisher]
    cover = params[:book_cover_url]
    nitem = params[:number_of_items]
    price = params[:price]
    total = price_format(nitem.to_f * price.to_f)
    city = params[:city]
    narea = params[:locality]
    bcondition = params[:item_condition]
    spreference = params[:descision_factor]
    auth_token = params[:auth_token]
    url = "http://#{$api_host}/user_requests/create/new.json?categ_id=51&user_request[buysell_category_id]=1321&user_request[item_info]=#{info}&user_request[item_spec]=#{specification}&user_request[item_code]=#{code}&user_request[book_authors]=#{author}&user_request[book_publisher]=#{publisher}&user_request[book_cover_url]=#{cover}&user_request[number_of_items]=#{nitem}&user_request[price]=#{price}&user_request[grand_total]=#{total}&user_request[city]=#{city}&user_request[locality]=#{narea}&user_request[item_condition]=#{bcondition}&user_request[descision_factor]=#{spreference}&auth_token=#{auth_token}"
    Rails.logger.warn url
    respond_to do |format|
      if auth_token.blank?
        $post_url = url
        Rails.logger.warn "setup post url to #{$post_url}"
        format.json { render :json => '{"success":false, "msg":"redirect", "id":"-1"}' }
      else
        uri = URI.parse(URI.encode(url.strip)) unless url.blank?
        Rails.logger.warn uri
        src = Net::HTTP.get(uri)
        format.json { render :json => src }
      end
    end
  end

  def cab_tour_post
    category = params[:category]
    scategory = params[:scategory]
    item_info = params[:item_info]
    cab_starting_point = params[:cab_starting_point]
    type_of_vehicle = params[:type_of_vehicle]
    adult = params[:adult]
    bags = params[:luggage]
    price = params[:price]
    narea = params[:landmark]
    city = params[:city]
    ac_non_ac = params[:ac_non_ac]
    cab_trip_detail = params[:cab_trip_detail]
    spreference = params[:descision_factor]
    currency_code = params[:currency_code]
    item_catalog_id = params[:item_catalog_id]
    pickup_day = params[:pickup_day]
    pickup_hh = params[:pickup_hh]
    pickup_mm = params[:pickup_mm]
    pickup_end_day = params[:pickup_end_day]
    term_agreement_decision = params[:term_agreement_decision]
    auth_token =params[:auth_token]
    url = "http://#{$api_host}/user_requests/create/new.json?categ_id=#{category}&user_request[buysell_category_id]=#{scategory}&user_request[item_info]=#{item_info}&user_request[cab_starting_point]=#{cab_starting_point}&user_request[adult]=#{adult}&user_request[cab_bags]=#{bags}&user_request[type_of_vehicle]=#{type_of_vehicle}&user_request[price]=#{price}&user_request[grand_total]=#{price}&user_request[landmark]=#{narea}&user_request[city]=#{city}&user_request[ac_non_ac]=#{ac_non_ac}&user_request[cab_trip_details]=#{cab_trip_detail}&user_request[descision_factor]=#{spreference}&user_request[currency_code]=#{currency_code}&user_request[item_catalog_id]=#{item_catalog_id}&pickup_day=#{pickup_day}&pickup_hh=#{pickup_hh}&pickup_mm=#{pickup_mm}&pickup_end_day=#{pickup_end_day}&term_agreement_decision=on&auth_token=#{auth_token}";
    Rails.logger.warn url
    respond_to do |format|
      if auth_token.blank?
        $post_url = url
        Rails.logger.warn "setup post url to #{$post_url}"
        format.json { render :json => '{"success":false, "msg":"redirect", "id":"-1"}' }
      else
        uri = URI.parse(URI.encode(url.strip)) unless url.blank?
        Rails.logger.warn uri
        src = Net::HTTP.get(uri)
        format.json { render :json => src }
      end
    end
  end

  def cab_droppOff_post
    category = params[:category]
    scategory = params[:scategory]
    item_info = params[:item_info]
    cab_starting_point = params[:cab_starting_point]
    type_of_vehicle = params[:type_of_vehicle]
    adult = params[:adult]
    bags = params[:luggage]
    price = params[:price]
    narea = params[:landmark]
    city = params[:city]
    ac_non_ac = params[:ac_non_ac]
    #cab_trip_detail = params[:cab_trip_detail]
    spreference = params[:descision_factor]
    currency_code = params[:currency_code]
    item_catalog_id = params[:item_catalog_id]
    pickup_day = params[:pickup_day]
    pickup_hh = params[:pickup_hh]
    pickup_mm = params[:pickup_mm]
    pickup_end_day = params[:pickup_end_day]
    dropoff_hh = params[:drop_off_hh]
    dropoff_mm = params[:drop_off_mm]
    term_agreement_decision = params[:term_agreement_decision]
    auth_token =params[:auth_token]
    url = "http://#{$api_host}/user_requests/create/new.json?categ_id=#{category}&user_request[buysell_category_id]=#{scategory}&user_request[item_info]=#{item_info}&user_request[cab_starting_point]=#{cab_starting_point}&user_request[adult]=#{adult}&user_request[cab_bags]=#{bags}&user_request[type_of_vehicle]=#{type_of_vehicle}&user_request[price]=#{price}&user_request[grand_total]=#{price}&user_request[landmark]=#{narea}&user_request[city]=#{city}&user_request[ac_non_ac]=#{ac_non_ac}&user_request[descision_factor]=#{spreference}&user_request[currency_code]=#{currency_code}&user_request[item_catalog_id]=#{item_catalog_id}&pickup_day=#{pickup_day}&pickup_hh=#{pickup_hh}&pickup_mm=#{pickup_mm}&pickup_end_day=#{pickup_end_day}&drop_off_hh=#{dropoff_hh}&drop_off_mm=#{dropoff_mm}&term_agreement_decision=on&auth_token=#{auth_token}";
    Rails.logger.warn url
    respond_to do |format|
      if auth_token.blank?
        $post_url = url
        Rails.logger.warn "setup post url to #{$post_url}"
        format.json { render :json => '{"success":false, "msg":"redirect", "id":"-1"}' }
      else
        uri = URI.parse(URI.encode(url.strip)) unless url.blank?
        Rails.logger.warn uri
        src = Net::HTTP.get(uri)
        format.json { render :json => src }
      end
    end
  end

  def real_estate
    category = params[:category]
    scategory = params[:scategory]
    city = params[:city]
    narea = params[:narea]
    iname = params[:iname]
    bedroom = params[:nroom]
    sq_feet = params[:sqft]
    start_date = params[:from]
    end_date = params[:to]
    price = params[:bnight]
    total = price
    spreference = params[:d_fact]
    auth_token = params[:auth_token]
    Rails.logger.warn "Category : #{category}"
    Rails.logger.warn "SCategory : #{scategory}"
    url = "http://#{$api_host}/user_requests/create/get.json?categ_id=#{category}&user_request[buysell_category_id]=#{scategory}&user_request[city]=#{city}&show_user_request_price=#{narea}&user_request[item_info]=#{iname}&user_request[no_of_bed_rooms]=#{bedroom}&start_date=#{start_date}&end_date=#{end_date}&user_request[price]=#{price}&user_request[grand_total]=#{total}&user_request[descision_factor]=#{spreference}&auth_token=#{auth_token}"
    Rails.logger.warn url
    respond_to do |format|
      if auth_token.blank?
        $post_url = url
        Rails.logger.warn "setup post url to #{$post_url}"
        format.json { render :json => '{"success":false, "msg":"redirect", "id":"-1"}' }
      else
        uri = URI.parse(URI.encode(url.strip)) unless url.blank?
        Rails.logger.warn uri
        src = Net::HTTP.get(uri)
        format.json { render :json => src }
      end
    end
  end

  def item_catalog_spec_result
    categ_id = params[:categ_id]
    parent_id = params[:parent_id]
    catalog_id = params[:catalog_id]
    url = "http://#{$api_host}/my_deals/item_catalog_detail/get.json?categ_id=#{categ_id}&parent_id=#{parent_id}&catalog_id=#{catalog_id}"
    src = Net::HTTP.get(URI.parse(url))
    respond_to do |format|
      format.json { render :json => src }
    end
  end

  def password_change
  old_p = params[:old_password]
  new_p = params[:old_password]
  c_p = params[:old_password]
  auth_token = params[:auth_token]
  url = "http://#{$api_host}/users/update_password/change_password.json?old_password=#{old_p}&new_password=#{new_p}&confirm_password=#{c_p}&auth_token=#{auth_token}"
  Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    Rails.logger.warn src
    respond_to do |format|
      format.json { render :json => src }
    end
  end

  def volume_deal_login
    Rails.logger.warn "deal login called"
    auth_token = params[:auth_token]
    url = "http://#{$api_host}/buyers/home/get.json?auth_token=#{auth_token}"
    src = Net::HTTP.get(URI.parse(url))

    respond_to do |format|
      format.json { render :json => src }
    end
  end

  def buyer_credit
    auth_token = params[:auth]
    url="http://#{$api_host}/coupons/ad_user_account_statement/get.json?auth_token=#{auth_token}"
    src = Net::HTTP.get(URI.parse(url))

    respond_to do |format|
      format.json { render :json => src }
    end
  end

  def buyer_request
    auth_token = params[:auth_token]
    url="http://#{$api_host}/merchant_offers/seller_user_requests/get.json?auth_token=#{auth_token}"
    src = Net::HTTP.get(URI.parse(url))
    respond_to do |format|
      format.json { render :json => src }
    end
  end

  def buyer_request_city
    city = params[:acityn]
    auth_token = params[:auth_token]
    url="http://#{$api_host}/merchant_offers/other_city_rqsts_accord/#{city}/get.json?auth_token=#{auth_token}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)

    respond_to do |format|
      format.json { render :json => src }
    end
  end

  def buyer_request_me
    auth_token = params[:auth_token]
    url="http://#{$api_host}/user_requests/list_requests/get.json?auth_token=#{auth_token}"
    src = Net::HTTP.get(URI.parse(url))

    respond_to do |format|
      format.json { render :json => src }
    end
  end

  def buyer_request_detail
    id = params[:id]
    auth_token = params[:auth_token]
    url="http://#{$api_host}/deals/request_details_json/#{id}/get.json?auth_token=#{auth_token}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    respond_to do |format|
      format.json { render :json => src }
    end
  end

  def buyer_reconfirm
    mid = params[:mid]
    auth_token = params[:auth_token]
    url="http://#{$api_host}/user_requests/reconfirm_offer/offer/reconfirm.json?mid=#{mid}&auth_token=#{auth_token}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)

    respond_to do |format|
      format.json { render :json => src }
    end
  end

  def buyer_purchases_item
    auth_token = params[:auth_token]
    url = "http://#{$api_host}/user_requests/bought_requests/get.json?auth_token=#{auth_token}"
    Rails.logger.warn url
    src = Net::HTTP.get(URI.parse(url))

    respond_to do |format|
      format.json { render :json => src }
    end
  end

  def buyer_deals_purchased
    auth_token = params[:auth_token]
    url = "http://#{$api_host}/deals/bought_deals/get.json?auth_token=#{auth_token}"
    Rails.logger.warn url
    src = Net::HTTP.get(URI.parse(url))

    respond_to do |format|
      format.json { render :json => src }
    end
  end

  def voucher_list
    id = params[:id]
    auth_token = params[:auth_token]
    url="http://#{$api_host}/deals/bought_deal_detail/#{id}/get.json?auth_token=#{auth_token}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)

    respond_to do |format|
      format.json { render :json => src }
    end
  end

  def veiw_all_adv
    auth_token = params[:auth_token]
    url = "http://#{$api_host}/coupons/get_ads_for_logged_in_user/get.json?auth_token=#{auth_token}"
    Rails.logger.warn url
    src = Net::HTTP.get(URI.parse(url))
    Rails.logger.warn src
    respond_to do |format|
      format.json { render :json => src }
    end
  end

  def user_info
    auth_token = params[:auth_token]

    url = "http://#{$api_host}/users/user_info/get.json?auth_token=#{auth_token}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)

    respond_to do |format|
      format.json { render :json => src }
    end
  end

  def buy_deal_ad_credit
    auth_token = params[:auth_token]
    url = "http://#{$api_host}/buyers/buy_with_ad_credit/#{params[:purchase_id]}/buy.json?auth_token=#{auth_token}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)

    respond_to do |format|
      format.json { render :json => src }
    end
  end
  
  def buy_offer_ad_credit
    auth_token = params[:auth_token]
    url = "http://#{$api_host}/user_requests/buy_with_ad_credit/#{params[:purchase_id]}/buy.json?auth_token=#{auth_token}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
  
    respond_to do |format|
      format.json { render :json => src }
    end
  end
  def get_offer_cost
    auth_token = params[:auth_token]
    mid = params[:mid]
    url = "http://#{$api_host}/my_deals/get_offer_cost/#{mid}/get.json?auth_token=#{auth_token}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
  
    respond_to do |format|
      format.json { render :json => src }
    end
  end
  def get_deal_cost
    auth_token = params[:auth_token]
    mid = params[:mid]
    qty = params[:qty]
    url = "http://#{$api_host}/my_deals/get_deal_cost/#{mid}/get.json?auth_token=#{auth_token}&qty=#{qty}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
  
    respond_to do |format|
      format.json { render :json => src }
    end
  end

  def prepare_buy
    mid = params[:mid]
    name = params[:name]
    amt = params[:amt]
    qty = params[:qty]
    b_addr = params[:b_addr]
    s_addr = params[:s_addr]
    city = params[:city]
    state = params[:state]
    zip = params[:zip]
    auth_token = params[:auth_token]
    url = "http://#{$api_host}/buyers/prepare_deal_buy/post.json?auth_token=#{auth_token}&deal_id=#{mid}&qty=#{qty}&bill_address=#{b_addr}&ship_address=#{s_addr}&postal_code=#{zip}&name=#{name}&city={city}&state=#{state}&redeemed_amt=#{amt}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)

    respond_to do |format|
      format.json { render :json => src }
    end
  end
  
  def prepare_buy_offer
    mid = params[:mid]
    name = params[:name]
    amt = params[:amt]
    qty = params[:qty]
    b_addr = params[:b_addr]
    s_addr = params[:s_addr]
    city = params[:city]
    state = params[:state]
    zip = params[:zip]
    auth_token = params[:auth_token]
    url = "http://#{$api_host}/user_requests/prepare_buy/post.json?auth_token=#{auth_token}&mid=#{mid}&qty=#{qty}&bill_address=#{b_addr}&ship_address=#{s_addr}&postal_code=#{zip}&name=#{name}&city={city}&state=#{state}&redeemed_amt=#{amt}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)

    respond_to do |format|
      format.json { render :json => src }
    end
  end
  def quiz_status
    auth_token = params[:auth_token]
    id = params[:id]
    url = "http://#{$api_host}/coupons/get_user_quiz_status/get.json?auth_token=#{auth_token}&ad_id=#{id}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    Rails.logger.warn src
    respond_to do |format|
      format.json { render :json => src }
    end
  end

  def ad_info
    auth_token = params[:auth_token]
    id = params[:id]
    url = "http://#{$api_host}/coupons/ad_quiz_info/#{id}/get.json?auth_token=#{auth_token}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    Rails.logger.warn src
    respond_to do |format|
      format.json { render :json => src }
    end
  end
  def initiate_quiz
    auth_token = params[:auth_token]
    ad_id = params[:ad_id]
    url = "http://#{$api_host}/coupons/initiate_quiz/get.json?ad_id=#{ad_id}&auth_token=#{auth_token}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    Rails.logger.warn src
    respond_to do |format|
      format.json { render :json => src }
    end
  end
  def pay_by_cash
    auth_token = params[:auth_token]
    moid = params[:moid]
    url = "http://#{$api_host}/user_requests/pay_by_cash/#{moid}/get.json?auth_token=#{auth_token}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    Rails.logger.warn src
    respond_to do |format|
      format.json { render :json => src }
    end
  end
  
  def timeout_quiz
    auth_token = params[:auth_token]
    ad_id = params[:ad_id]
    url = "http://#{$api_host}/coupons/timeout_quiz/get.json?ad_id=#{ad_id}&auth_token=#{auth_token}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    Rails.logger.warn src
    respond_to do |format|
      format.json { render :json => src }
    end
  end
  def update_feedback
    auth_token = params[:auth_token]
    ad_id = params[:ad_id]
    rating_input = params[:rating_input]
    time_period = params[:time_period]
    url = "http://#{$api_host}/coupons/update_feedback/get.json?ad_id=#{ad_id}&auth_token=#{auth_token}&rating_input=#{rating_input}&time_period=#{time_period}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    Rails.logger.warn src
    respond_to do |format|
      format.json { render :json => src }
    end
  end
  def validate_quiz
    auth_token = params[:auth_token]
    ad_id = params[:ad_id]
    total_questions = params[:total_questions]
    que_params = ""
    grp_params = ""
    count = 1
    Rails.logger.warn "total_questions: #{total_questions}, Ad ID: #{ad_id}, Auth_token: #{auth_token}"
    for i in 1..total_questions.to_i
      queID_param = "que_id"+ count.to_s
      grp_param = "group"+ count.to_s
      Rails.logger.warn queID_param
      question_id = params[queID_param].strip unless params[queID_param].blank?
      grp_param_val = params[grp_param].strip unless params[grp_param].blank?
      Rails.logger.warn grp_param
      Rails.logger.warn question_id
      if count == 1
        que_params += "#{queID_param}=#{question_id}"
        grp_params += "#{grp_param}=#{grp_param_val}"
      else
        que_params += "&#{queID_param}=#{question_id}"
        grp_params += "&#{grp_param}=#{grp_param_val}"
      end
      count += 1
    end
    url = "http://#{$api_host}/coupons/validate_quiz/validate.json?#{que_params}&auth_token=#{auth_token}&#{grp_params}&ad_id=#{ad_id}&total_questions=#{total_questions}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)

    respond_to do |format|
      format.json { render :json => src }
    end
  end

  def sign_up
    email = params[:email]
    password = params[:password]
    fname = params[:fname]
    lname = params[:lname]
    Rails.logger.warn "last name is #{lname}"
    mobile = params[:mobile]
    city = params[:city]
    user_type = params[:user_type]
    url = "http://#{$api_host}/users/create_guest/new.json?user[fname]=#{fname}&user[lname]=#{lname}&user[password]=#{password}&user[email]=#{email}&address[city]=#{city}&address[mobile]=#{mobile}&user_type=#{user_type}&partnerId=#{$partner_id}"
    Rails.logger.warn url
    respond_to do |format|
      uri = URI.parse(URI.encode(url.strip)) unless url.blank?
      Rails.logger.warn uri
      src = Net::HTTP.get(uri)
      Rails.logger.warn src
      format.json { render :json => src }
    end
  end

  def verify_email
    email_code = params[:email_code]
    user_id = params[:user_id]
    url = "http://#{$api_host}/users/verify_guest/verify.json?email_code=#{email_code}&user_id=#{user_id}"
    Rails.logger.warn url
    respond_to do |format|
      uri = URI.parse(URI.encode(url.strip)) unless url.blank?
      Rails.logger.warn uri
      src = Net::HTTP.get(uri)
      Rails.logger.warn src
      parsed_json = ActiveSupport::JSON.decode(src)
      Rails.logger.warn "user type from JSON"
      Rails.logger.warn parsed_json['user_type']
      session[:uType] = parsed_json['user_type']
      Rails.logger.warn "user type from variable"
      Rails.logger.warn session[:uType]
      format.json { render :json => src }
    end
  end
  
  def verify_email_acc
    email_code = params[:email_code]
    verif_email = params[:verif_email]
    url = "http://#{$api_host}/users/verify_guest_email/verify.json?email_code=#{email_code}&verif_email=#{verif_email}"
    Rails.logger.warn url
    respond_to do |format|
      uri = URI.parse(URI.encode(url.strip)) unless url.blank?
      Rails.logger.warn uri
      src = Net::HTTP.get(uri)
      Rails.logger.warn src
      parsed_json = ActiveSupport::JSON.decode(src)
      Rails.logger.warn "user type from JSON"
      Rails.logger.warn parsed_json['user_type']
      session[:uType] = parsed_json['user_type']
      Rails.logger.warn "user type from variable"
      Rails.logger.warn session[:uType]
      format.json { render :json => src }
    end
  end

  def mysettings_data
    auth_token = params[:auth_token]
    url = "http://#{$api_host}/my_deals/mysettings_data/get.json?auth_token=#{auth_token}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    Rails.logger.warn src
    respond_to do |format|
      format.json { render :json => src }
    end
  end

  def update_settings
    url_params = ""
    auth_token = params[:auth_token]
    user_type = params[:user_type]
    category_ids_params = ""
    bcategory_ids_params = ""
    if !params[:category_ids].nil?
      params[:category_ids].each do |ci|
        category_ids_params += "#{ci},"
      end
    end
    if !params[:buysell_category_ids].nil?
      params[:buysell_category_ids].each do |bci|
        bcategory_ids_params += "#{bci},"
      end
    end
    lead_preference = params[:lead_preference]
    business_name = params[:business_name]
    contact_detail = params[:contact_detail]
    website_url = params[:website_url]
    logo = params[:merchant_img]
    bank_name = params[:bank_name]
    branch = params[:branch]
    checking = params[:checking]
    swift_code = params[:swift_code]
    routing = params[:routing]
    merchant_img = params[:merchant_img]
    
     args = { 
      'user_type' => user_type, 
      'lead_preference' => lead_preference,
      'merchant[business_name]' => business_name,
      'merchant[contact_detail]' => contact_detail,
      'merchant[website_url]' => website_url,
      'merchant[bank_name]' => bank_name,
      'merchant[branch]' => branch,
      'merchant[checking]' => checking,
      'merchant[swift_code]' => swift_code,
      'merchant[routing]' => routing,
      'category_ids' => category_ids_params,
      'buysell_category_ids' => bcategory_ids_params,
      'auth_token' => auth_token
    }
    
    url = "http://#{$api_host}/my_deals/update_settings/update.json"
    Rails.logger.warn url
    
    begin
      response, data = Net::HTTP.post_form(URI.parse(url), args)
      src = response.body
      Rails.logger.warn src
    rescue Exception => exc
        src = '{"success":false, "msg":"Error while saving your preferences. Please try again."'+exc.message+'""}'
    end
    respond_to do |format|
      format.json { render :json => src }
    end
  end

  def update_profile
    auth_token = params[:auth_token]
    fname = params[:fname]
    lname = params[:lname]
    city = params[:city]
    zip = params[:zip]
    fax = params[:fax]
    billing_addr = params[:billing_addr]
    shipping_addr = params[:shipping_addr]
    url_params = ""
    url_params += "user[fname]=#{fname}&user[lname]=#{lname}&address[city]=#{city}&address[zip]=#{zip}&address[fax]=#{fax}&address[billing_addr]=#{billing_addr}&address[shipping_addr]=#{shipping_addr}"
    url = "http://#{$api_host}/users/update/update.json?#{url_params}&auth_token=#{auth_token}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    respond_to do |format|
      format.json { render :json => src }
    end
  end

  def send_code
    auth_token = params[:auth_token]
    mobile_no = params[:mob]
    url = "http://#{$api_host}/users/send_verification_code/send.json?mobile_no=#{mobile_no}&auth_token=#{auth_token}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    respond_to do |format|
      format.json { render :json => src }
    end
  end

  def verify_code
    auth_token = params[:auth_token]
    verif_code = params[:code]
    url = "http://#{$api_host}/users/verify_code/verify.json?verif_code=#{verif_code}&auth_token=#{auth_token}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    respond_to do |format|
      format.json { render :json => src }
    end
  end

  def changeMY_password
    auth_token = params[:auth_token]
    new_password = params[:new_password]
    confirm_password = params[:confirm_password]
    old_password = params[:old_password]
    url = "http://#{$api_host}/users/update_password/change_password.json?new_password=#{new_password}&confirm_password=#{confirm_password}&old_password=#{old_password}&auth_token=#{auth_token}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    respond_to do |format|
      format.json { render :json => src }
    end
  end

  def seller_user_requests
    auth_token = params[:auth_token]
    url = "http://#{$api_host}/merchant_offers/seller_user_requests/get.json?auth_token=#{auth_token}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    respond_to do |format|
      format.json { render :json => src }
    end
  end
  
  def save_offer
    auth_token = params[:auth_token]
    offer_price = params[:offer_price]
    total_price = params[:total_price]
    currency_code = params[:currency_code]
    
    amty_ids_params = ""
    if !params[:amenity_ids].nil?
      params[:amenity_ids].each do |ci|
        amty_ids_params += "&amenity_ids[]=#{ci}"
      end
    end
    onbehalf_hotel_name = params[:onbehalf_hotel_name]
    onbehalf_hotel_addr = params[:onbehalf_hotel_addr]
    onbehalf_hotel_contact = params[:onbehalf_hotel_contact]
    fee_agreed = params[:transaction_fee]
    minimum_offer_time = params[:minimum_offer_time]
    shipping_charge = params[:shipping_charge]
    tax_percent = params[:tax_percent]
    usr_req_id = params[:user_reqID]
    cab_max_km = params[:cab_max_km]
    item_info = params[:item_info]
    company_name = params[:company_name]
    contact_person = params[:contact_person]
    contact_number = params[:contact_number]
    mode_of_shipping = params[:mode_of_shipping]
    condition = params[:condition]
    mrp = params[:mrp]
    color_pref = params[:color_pref]
    make_year = params[:make_year]
    tenure_term = params[:tenure_term]
    interest_rate = params[:interest_rate]
    warranty = params[:warranty]
    warranty_tenure = params[:warranty_tenure]
    
    url_token = "?usr_req_id=#{usr_req_id}"
    
    url_token += "&merchant_offer[warranty_tenure]=#{warranty_tenure}"  unless warranty_tenure.blank?
    url_token += "&merchant_offer[warranty]=#{warranty}"  unless warranty.blank?
    url_token += "&merchant_offer[interest_rate]=#{interest_rate}"  unless interest_rate.blank?
    url_token += "&merchant_offer[tenure_term]=#{tenure_term}"  unless tenure_term.blank?
    url_token += "&merchant_offer[make_year]=#{make_year}"  unless make_year.blank?
    url_token += "&merchant_offer[color_pref]=#{color_pref}"  unless color_pref.blank?
    url_token += "&merchant_offer[mrp]=#{mrp}"  unless mrp.blank?
    url_token += "&merchant_offer[condition]=#{condition}"  unless condition.blank?
    url_token += "&merchant_offer[mode_of_shipping]=#{mode_of_shipping}"  unless mode_of_shipping.blank?
    url_token += "&merchant_offer[contact_number]=#{contact_number}"  unless contact_number.blank?
    url_token += "&merchant_offer[contact_person]=#{contact_person}"  unless contact_person.blank?
    url_token += "&merchant_offer[company_name]=#{company_name}"  unless company_name.blank? 
    url_token += "&merchant_offer[item_info]=#{item_info}" unless item_info.blank?
    url_token += "&merchant_offer[cab_max_km]=#{cab_max_km}"  unless cab_max_km.blank?
    url_token += "&merchant_offer[tax_percent]=#{tax_percent}"  unless tax_percent.blank?
    url_token += "&merchant_offer[shipping_charge]=#{shipping_charge}"  unless shipping_charge.blank?
    url_token += "&merchant_offer[minimum_offer_time]=#{minimum_offer_time}"  unless minimum_offer_time.blank?
    url_token += "&merchant_offer[fee_agreed]=#{fee_agreed}"  unless fee_agreed.blank?
    url_token += "&merchant_offer[onbehalf_hotel_name]=#{onbehalf_hotel_name}"  unless onbehalf_hotel_name.blank?
    url_token += "&merchant_offer[onbehalf_hotel_contact]=#{onbehalf_hotel_contact}"  unless onbehalf_hotel_contact.blank?
    url_token += "&merchant_offer[onbehalf_hotel_addr]=#{onbehalf_hotel_addr}"  unless onbehalf_hotel_addr.blank?
    url_token += "&merchant_offer[currency_code]=#{currency_code}"  unless currency_code.blank?
    url_token += "&merchant_offer[total_price]=#{total_price}"  unless total_price.blank?
    url_token += "&merchant_offer[offer_price]=#{offer_price}"  unless offer_price.blank?
    url_token += "#{amty_ids_params}"  unless amty_ids_params.blank?
    url_token += "&auth_token=#{auth_token}"  unless auth_token.blank?
    
    Rails.logger.warn "url_token: #{url_token}"
    url = "http://#{$api_host}/deals/saveoffer/post.json#{url_token}"
    
    Rails.logger.warn "URL: #{url}"
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    Rails.logger.warn src
    respond_to do |format|
      format.json { render :json => src }
    end
  end
  def offer_details
    auth_token = params[:auth_token]
    moid = params[:moid]
    url = "http://#{$api_host}/deals/get_offer_obj_by_id/get.json?moid=#{moid}&auth_token=#{auth_token}"
    Rails.logger.warn "URL: #{url}"
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    Rails.logger.warn src
    respond_to do |format|
      format.json { render :json => src }
    end
  end
  def buyer_reconfirm
    auth_token = params[:auth_token]
    moid = params[:mid]
    url = "http://#{$api_host}/user_requests/reconfirm_offer/reconfirm.json?mid=#{moid}&auth_token=#{auth_token}"
    Rails.logger.warn "URL: #{url}"
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    Rails.logger.warn src
    respond_to do |format|
      format.json { render :json => src }
    end
  end 
  def reject_offer
    auth_token = params[:auth_token]
    moid = params[:mid]
    url = "http://#{$api_host}/user_requests/reject_offer/reject.json?mid=#{moid}&auth_token=#{auth_token}"
    Rails.logger.warn "URL: #{url}"
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    Rails.logger.warn src
    respond_to do |format|
      format.json { render :json => src }
    end
  end
  #Jobs related calls
  def candidate_profile
    auth_token = params[:auth_token]
    url = "http://#{$api_host}/jobs/full_job_profile/get.json?auth_token=#{auth_token}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    Rails.logger.warn src
    respond_to do |format|
      format.json { render :json => src }
    end
  end
  
  def getJob_titles
    parent_id = params[:parent_id]
    url = "http://#{$api_host}/jobs/getJob_titles/get.json?parent_id=#{parent_id}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    Rails.logger.warn src
    respond_to do |format|
      format.json { render :json => src }
    end
  end
  
  def getJob_degrees
    q_id = params[:q_id]
    url = "http://#{$api_host}/jobs/getJob_degrees/get.json?qualification_id=#{q_id}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    Rails.logger.warn src
    respond_to do |format|
      format.json { render :json => src }
    end
  end
  def getJob_splization
    parent_id = params[:parent_id]
    url = "http://#{$api_host}/jobs/getJob_splization/get.json?parent_id=#{parent_id}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    Rails.logger.warn src
    respond_to do |format|
      format.json { render :json => src }
    end
  end
  def list_matched_jobs_data
    auth_token = params[:auth_token]
    url = "http://#{$api_host}/jobs/job_listing/get.json?auth_token=#{auth_token}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    Rails.logger.warn src
    respond_to do |format|
      format.json { render :json => src }
    end
  end
  def job_detail
    job_id = params[:job_id]
    url = "http://#{$api_host}/jobs/job_detail_apply/#{job_id}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    Rails.logger.warn src
    respond_to do |format|
      format.json { render :json => src }
    end
  end
  def candidate_profile_data
    auth_token = params[:auth_token]
    url = "http://#{$api_host}/jobs/view_my_profile/get.json?auth_token=#{auth_token}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    Rails.logger.warn src
    respond_to do |format|
      format.json { render :json => src }
    end
  end 
  def jobs_candidate_profile_data
    auth_token = params[:auth_token]
    application_id = params[:application_id]
    posting_id = params[:posting_id]
    applicant_id = params[:applicant_id]
    url = "http://#{$api_host}/jobs/candidate_profile_for_job/get.json?auth_token=#{auth_token}&application_id=#{application_id}&job_post_id=#{posting_id}&applicant_id=#{applicant_id}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    Rails.logger.warn src
    respond_to do |format|
      format.json { render :json => src }
    end
  end
  def job_reject_application
    auth_token = params[:auth_token]
    application_id = params[:application_id]
    url = "http://#{$api_host}/jobs/reject_application/#{application_id}.json?auth_token=#{auth_token}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    Rails.logger.warn src
    respond_to do |format|
      format.json { render :json => src }
    end
  end
  def job_shortlist_application
    auth_token = params[:auth_token]
    application_id = params[:application_id]
    url = "http://#{$api_host}/jobs/shortlist_application/#{application_id}.json?auth_token=#{auth_token}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    Rails.logger.warn src
    respond_to do |format|
      format.json { render :json => src }
    end
  end
  def jobs_applied_by_me
    auth_token = params[:auth_token]
    url = "http://#{$api_host}/jobs/my_jobs_applied/get.json?auth_token=#{auth_token}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    Rails.logger.warn src
    respond_to do |format|
      format.json { render :json => src }
    end
  end
  def jobs_posted_by_me
    auth_token = params[:auth_token]
    url = "http://#{$api_host}/jobs/my_jobs_posted_list/get.json?auth_token=#{auth_token}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    Rails.logger.warn src
    respond_to do |format|
      format.json { render :json => src }
    end
  end
  def jobs_is_profile_created
    auth_token = params[:auth_token]
    url = "http://#{$api_host}/jobs/is_profile_created/get.json?auth_token=#{auth_token}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    Rails.logger.warn src
    respond_to do |format|
      format.json { render :json => src }
    end
  end
  def list_job_applicants
    auth_token = params[:auth_token]
    jb_posting_id = params[:posting_id]
    url = "http://#{$api_host}/jobs/condidate_application/#{jb_posting_id}.json?auth_token=#{auth_token}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    Rails.logger.warn src
    respond_to do |format|
      format.json { render :json => src }
    end
  end
  def apply_job_post
    job_posting_id = params[:job_posting_id]
    auth_token = params[:auth_token]
    if !params[:posting_required_skills].blank?
      posting_required_skills = params[:posting_required_skills]
    else
      posting_required_skills = 0
    end
    having_skill_ids = ""
    answer_to = ""
    if !params[:having_skill_ids].nil?
      params[:having_skill_ids].each do |ci|
        having_skill_ids += "&having_skill_ids[]=#{ci}";
      end
    end
    notice_period = params[:notice_period]
    total_job_questions = params[:total_job_questions]
    if !total_job_questions.blank?
        params[:job_que_ids].split("~").each do |item|
        if item.to_s !=""
          answer_params = "answer_to_#{item.to_s}"
          answer_to += "&answer_to_#{item.to_s}=#{params[answer_params]}"
        end   
      end
    end 
    url_params = "job_posting_id=#{job_posting_id}&notice_period=#{notice_period}&posting_required_skills=#{posting_required_skills}"
    url_params += "#{having_skill_ids}"
    url_params += "#{answer_to}"
    url_params += "&auth_token=#{auth_token}"
    Rails.logger.warn url_params
    
    url = "http://#{$api_host}/jobs/apply_job/get.json?#{url_params}"
    Rails.logger.warn url
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    Rails.logger.warn src
    respond_to do |format|
      format.json { render :json => src }
    end 
  end
  def save_job_profile
    #save resume_doc and image file temporarily:
      user_uid = params[:user_uid]
      
      upload = params[:upload]
      if !upload.nil?
        name =  upload['resume_doc'].original_filename
        @ext = name.split(".")
        resume_name = user_uid+"_resume."+@ext[1]
        post = DataFile.save(params[:upload], resume_name, 'public/job_profile', upload['resume_doc'])
      end
      myupload = params[:pupload]
      if !myupload.nil?
        name =  myupload['profile_pic'].original_filename
        @ext = name.split(".")
        pic_name = user_uid+"_pic."+@ext[1]
        post = DataFile.save(params[:pupload], pic_name, 'public/job_profile', myupload['profile_pic'])
      end
    resume_url = "http://m.mydeals247.com/job_profile/#{resume_name}" unless resume_name.nil?
    pic_url = "http://m.mydeals247.com/job_profile/#{pic_name}" unless pic_name.nil?
    
    url_token = ""
    job_profile_id = params[:job_profile_id]
    url_token += "?job_profile_id=#{job_profile_id}"
    f_Name = params[:fname]
    l_Name = params[:lname]
    cur_city = params[:cur_city]
    video_url = params[:video_url]
    language_known = params[:language_known]
    gender = params[:gender]
    is_experienced = params[:is_experienced]
    job_industry = params[:job_industry]
    Rails.logger.warn f_Name
    Rails.logger.warn l_Name
    url_token += "&job_profile[f_Name]=#{f_Name}"  unless f_Name.blank?
    url_token += "&job_profile[l_Name]=#{l_Name}"  unless l_Name.blank?
    url_token += "&job_profile[cur_city]=#{cur_city}"  unless cur_city.blank?
    url_token += "&job_profile[video_url]=#{video_url}"  unless video_url.blank?
    url_token += "&job_profile[language_known]=#{language_known}"  unless language_known.blank?
    url_token += "&job_profile[is_experienced]=#{is_experienced}"  unless is_experienced.blank?
    url_token += "&job_industry=#{job_industry}"  unless job_industry.blank?
    url_token += "&job_profile[gender]=#{gender}"  unless gender.blank?
    
    url_token += "&resume_url=#{resume_url}"
    url_token += "&pic_url=#{pic_url}"
    
    functional_areas_params = ""
    if !params[:functional_areas].nil?
      params[:functional_areas].each do |ci|
        functional_areas_params += "&functional_areas[]=#{ci}"
      end
    end
    url_token += functional_areas_params
    education_specialization_params = ""
    if !params[:education_specialization].nil?
      params[:education_specialization].each do |ci|
        education_specialization_params += "&education_specialization[]=#{ci}"
      end
    end
    url_token += education_specialization_params
    experience_level_id = params[:experience_level_id]
    url_token += "&job_profile[experience_level_id]=#{experience_level_id}"  unless experience_level_id.blank?
    
    total_experience_year = params[:total_experience_year]
    url_token += "&total_experience_year=#{total_experience_year}"  unless total_experience_year.blank?
    
    total_experience_month = params[:total_experience_month]
    url_token += "&total_experience_month=#{total_experience_month}"  unless total_experience_month.blank?
    
    prefered_city1 = params[:prefered_city1]
    url_token += "&prefered_city1=#{prefered_city1}"  unless prefered_city1.blank?
    
    prefered_city2 = params[:prefered_city2]
    url_token += "&prefered_city2=#{prefered_city2}"  unless prefered_city2.blank?
    
    prefered_city3 = params[:prefered_city3]
    url_token += "&prefered_city3=#{prefered_city3}"  unless prefered_city3.blank?
    
    desired_job_type = params[:desired_job_type]
    url_token += "&desired_job_type=#{desired_job_type}"  unless desired_job_type.blank?
    
    id_curSalaryL = params[:id_curSalaryL]
    url_token += "&id_curSalaryL=#{id_curSalaryL}"  unless id_curSalaryL.blank?
    
    id_curSalaryK = params[:id_curSalaryK]
    url_token += "&id_curSalaryK=#{id_curSalaryK}"  unless id_curSalaryK.blank?
    
    id_exSalaryL = params[:id_exSalaryL]
    url_token += "&id_exSalaryL=#{id_exSalaryL}"  unless id_exSalaryL.blank?
    
    id_exSalaryK = params[:id_exSalaryK]
    url_token += "&id_exSalaryK=#{id_exSalaryK}"  unless id_exSalaryK.blank?
    
    company_name = params[:company_name]
    cur_company_title = params[:cur_company_title]
    cur_company_from_month = params[:cur_company_from_month]
    cur_company_from_year = params[:cur_company_from_year]
    cur_company_to_month = params[:cur_company_to_month]
    cur_company_to_year = params[:cur_company_to_year]
    cur_company_description = params[:cur_company_description]
    
    url_token += "&job_profile[company_name]=#{company_name}"  unless company_name.blank?
    url_token += "&job_profile[cur_company_title]=#{cur_company_title}"  unless cur_company_title.blank?
    url_token += "&job_profile[cur_company_from_month]=#{cur_company_from_month}"  unless cur_company_from_month.blank?
    url_token += "&job_profile[cur_company_from_year]=#{cur_company_from_year}"  unless cur_company_from_year.blank?
    url_token += "&job_profile[cur_company_to_month]=#{cur_company_to_month}"  unless cur_company_to_month.blank?
    url_token += "&job_profile[cur_company_to_year]=#{cur_company_to_year}"  unless cur_company_to_year.blank?
    url_token += "&job_profile[cur_company_description]=#{cur_company_description}"  unless cur_company_description.blank?
    
    experience_ids = params[:experience_ids]
    url_token += "&experience_ids=#{experience_ids}"  unless experience_ids.blank?
    
    past_company_parms = ""
    experience_ids.split(",").each do |item|
      if !item.blank? && item != ''
        company_name = "past_company_name_#{item}"
        job_title = "past_job_title_#{item}"
        from_month = "past_company_from_month_#{item}"
        from_year = "past_company_from_year_#{item}"
        to_month = "past_company_to_month_#{item}"
        to_year = "past_company_to_year_#{item}"
        job_desc = "past_company_description_#{item}"
        
        company_name_val = params[company_name]
        job_title_val = params[job_title]
        from_month_val = params[from_month]
        from_year_val = params[from_year]
        to_month_val = params[to_month]
        to_year_val = params[to_year]
        job_desc_val = params[job_desc]
        past_company_parms += "&#{company_name}=#{company_name_val}&#{job_title}=#{job_title_val}&#{from_month}=#{from_month_val}&#{from_year}=#{from_year_val}&#{to_month}=#{to_month_val}&#{to_year}=#{to_year_val}&#{job_desc}=#{job_desc_val}"
        Rails.logger.warn "#{item}. company_name: #{company_name_val}, job_title: #{job_title_val}, from_month: #{from_month_val}, from_year: #{from_year_val}, to_month: #{to_month_val}, to_year: #{to_year_val}, job_desc: #{job_desc_val}"
      end
    end
    url_token += past_company_parms unless past_company_parms.blank?
    qualification_level = params[:qualification_level]
    url_token += "&qualification_level=#{qualification_level}"  unless qualification_level.blank?
    institute_name = params[:institute_name]
    course_type = params[:course_type]
    edu_frm_year = params[:edu_frm_year]
    edu_to_year =  params[:edu_to_year]
    edu_description = params[:edu_description]
    percentage = params[:percentage]
    url_token += "&job_profile[institute_name]=#{institute_name}"  unless institute_name.blank?
    url_token += "&job_profile[course_type]=#{course_type}"  unless course_type.blank?
    url_token += "&job_profile[edu_frm_year]=#{edu_frm_year}"  unless edu_frm_year.blank?
    url_token += "&job_profile[edu_to_year]=#{edu_to_year}"  unless edu_to_year.blank?
    url_token += "&job_profile[percentage]=#{percentage}"  unless percentage.blank?
    url_token += "&job_profile[edu_description]=#{edu_description}"  unless edu_description.blank?
    

    education_ids = params[:education_ids]
    url_token += "&education_ids=#{education_ids}"  unless education_ids.blank?
    past_edu_parms = ""
    education_ids.split(",").each do |item|
      if !item.blank? && item != ''
        qualification_level = "past_edu_qualification_level_#{item}"
        edu_degree = "past_edu_degree_#{item}"
        edu_institute = "past_edu_institute_#{item}"
        edu_course_type = "past_edu_course_type_#{item}"
        edu_from_year = "past_edu_from_year_#{item}"
        edu_to_year = "past_edu_to_year_#{item}"
        edu_desc = "past_edu_description_#{item}"
        edu_marks_perc = "past_edu_marks_perc_#{item}"
        
        qualification_level_val = params[qualification_level]
        edu_degree_val = params[edu_degree]
        edu_institute_val = params[edu_institute]
        edu_course_type_val = params[edu_course_type]
        edu_from_year_val = params[edu_from_year]
        edu_to_year_val = params[edu_to_year]
        edu_desc_val = params[edu_desc]
        edu_marks_perc_val = params[edu_marks_perc]
        past_edu_parms += "&#{qualification_level}=#{qualification_level_val}&#{edu_degree}=#{edu_degree_val}&#{edu_institute}=#{edu_institute_val}&#{edu_course_type}=#{edu_course_type_val}&#{edu_from_year}=#{edu_from_year_val}&#{edu_to_year}=#{edu_to_year_val}&#{edu_desc}=#{edu_desc_val}"
        past_edu_parms += "&#{edu_marks_perc}=#{edu_marks_perc_val}"
        Rails.logger.warn "#{item}. qualification_level: #{qualification_level_val}, edu_degree: #{edu_degree_val}, edu_institute: #{edu_institute_val}, edu_course_type: #{edu_course_type_val}, edu_from_year: #{edu_from_year_val}, edu_to_year: #{edu_to_year_val}, edu_desc: #{edu_desc_val}, edu_marks_perc: #{edu_marks_perc_val}"
      end
    end
    url_token += past_edu_parms unless past_edu_parms.blank?
    skill_ids = params[:skill_ids]
    url_token += "&skill_ids=#{skill_ids}"  unless skill_ids.blank?
    skill_set_parms = ""
    skill_ids.split(",").each do |item|
      if !item.blank? && item != ''
        skill_name = "profile_skill_#{item}"
        skill_rating = "profile_rating_#{item}"
        skill_name_val = params[skill_name]
        skill_rating_val = params[skill_rating]
        Rails.logger.warn "#{item}. skill_name: #{skill_name_val}, skill_rating: #{skill_rating_val}"
        skill_set_parms += "&#{skill_name}=#{skill_name_val}&#{skill_rating}=#{skill_rating_val}"
      end
    end
    url_token += skill_set_parms unless skill_set_parms.blank?
    certification_ids = params[:certification_ids]
    url_token += "&certification_ids=#{certification_ids}"  unless certification_ids.blank?
    certification_parms_str = ""
    certification_ids.split(",").each do |item|
      if !item.blank? && item != ''
        certif_desc = "certi_desc_#{item}"
        certif_title = "certi_title_#{item}"
        certif_year_from = "certi_year_#{item}"
        certif_desc_val = params[certif_desc]
        certif_title_val = params[certif_title]
        certif_year_from_val = params[certif_year_from]
        Rails.logger.warn "#{item}. certif_desc: #{certif_desc_val}, certif_title: #{certif_title_val}, certif_year_from: #{certif_year_from_val}"
        certification_parms_str += "&#{certif_desc}=#{certif_desc_val}&#{certif_title}=#{certif_title_val}&#{certif_year_from}=#{certif_year_from_val}"
      end
    end
    url_token += certification_parms_str unless certification_parms_str.blank?
    public_url = params[:public_url]
    url_token += "&job_profile[public_url]=#{public_url}"  unless public_url.blank?
    auth_token = params[:auth_token]
    url_token += "&auth_token=#{auth_token}"  unless auth_token.blank?

    Rails.logger.warn "url_token: #{url_token}"
    
    url = "http://#{$api_host}/jobs/save_profile/post.json#{url_token}"
    Rails.logger.warn "URL: #{url}"
    uri = URI.parse(URI.encode(url.strip)) unless url.blank?
    Rails.logger.warn uri
    src = Net::HTTP.get(uri)
    Rails.logger.warn src
    parsed_json = ActiveSupport::JSON.decode(src)
    Rails.logger.warn "elect to get user type from JSON"
    success = parsed_json['success']
    Rails.logger.warn success
    Rails.logger.warn success == "true"
    msg = parsed_json['msg']
    urltoredirect = "/my_deals/employee_home?notice=Your+Job+profile+was+successfully+updated."
    respond_to do |format|
      #format.html { render :action => "employee_home", :msg => msg }
      format.html { redirect_to(urltoredirect) } 
    end
  end
end
