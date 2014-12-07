require 'rack/oauth2'
class FacebooksController < ApplicationController
  before_filter :require_authentication, :only => :destroy
  def facebook_success
    redirect_to client.authorization_uri(
      :scope => Facebook.config[:perms]
    )
  end

  def facebook_failure
    redirect_to :controller=>'my_deals', :action=>'index', :notice => "Facebook returns no success!"
  end

  def facebook_connected
    Rails.logger.warn "********* from facebook connected ******************"
    Rails.logger.warn request.session_options[:id]
    Rails.logger.warn request.env['HTTP_USER_AGENT'].downcase
    Rails.logger.warn request.remote_ip
    Rails.logger.warn "********* done ******************"
    client.authorization_code = params[:code]
    access_token = client.access_token!
    fb_user = FbGraph::User.me(access_token).fetch
    facbook_uid = fb_user.identifier
    usr = User.find_by_email(fb_user.email)
    if(session[:user].blank?)
      user = User.first(:conditions => "facebook_uid = '#{facbook_uid}'")
      if user.nil? && usr.nil?
        @user = User.new
        ip = request.remote_ip
        url = "http://api.ipinfodb.com/v3/ip-city/?key=92eb0f40afa8b6d206f32d9b8b576d9f1b1f4018e5ad0d54be843ba2728e85b7&ip=#{ip}"
        src = Net::HTTP.get(URI.parse(url))
        datas = src.split(";")
        pwd = generate8
        encoded_str = ActiveSupport::Base64.encode64("#{fb_user.email}:#{pwd}")
        fName = "-"
        lName = "-"
        fName = fb_user.first_name unless fb_user.first_name.nil?
        lName = fb_user.last_name unless fb_user.last_name.nil?
        @user.fname=fName
        @user.lname=lName
        @user.display_name = fName + " " + lName
        @user.email=fb_user.email
        @user.encryptPass(pwd)
        @user.password_confirmation = @user.password
        @user.facebook_uid=fb_user.identifier
        @user.email_verif_code = pwd
        @user.user_type="user"
        @user.sub_type = "buyer"
        @user.is_email_verified = true
        @user.user_status = "active"
        @user.uid = generate30
        @user.pass_flag = false
        @user.save
        
        @address = Address.new
        @address.user_id = @user.id
        @address.city = datas[6].downcase.strip
        @address.state = datas[5].downcase
        @address.country = datas[4].downcase
        @address.address = "---"
        @address.mobile = "---"
        @address.zip = "---"
        @address.latilong = city_latilong(@address.city.to_s)
        @address.save
        UserPref.find_or_create_by_user_id_and_city_and_state_and_country_and_latilong(@user.id, @address.city, @address.state, @address.country, @address.latilong)
        @categories = Category.where("status = true").order("name")
        if !@categories.blank?
          deal_cat_values = []
          @categories.each do |category|
            deal_cat_values.push "(#{@user.id}, #{category.id}, NOW(), NOW())"
          end
          UserInterest.connection.execute "INSERT INTO `user_interests`(user_id, category_id, created_at, updated_at) values #{deal_cat_values.join(", ")}" unless deal_cat_values.blank?
        end
        @uas = UserActiveSession.first(:conditions => ["user_id = ? and created_at > ?", @user.id, (Time.now - 30.minutes).in_time_zone.utc().strftime("%Y-%m-%d %H:%M:%S")]) unless @user.nil?
        http_agent = request.env['HTTP_USER_AGENT'].downcase
        if @uas.nil?
          Rails.logger.warn "uas is nil"
          @user.user_active_sessions.destroy_all unless @user.user_active_sessions.nil?
          @uas = UserActiveSession.new
          @uas.user_id = @user.id
          @uas.session_id = request.session_options[:id]
          @uas.ip_address = request.remote_ip
          @uas.agent_browser = http_agent
          @uas.save
          Rails.logger.warn "logged in here"
        else
          if @uas.agent_browser != http_agent
            redirect_to :controller=>'my_deals', :action=>'index', :notice => "You are already logged in other browser/device, Please logout and log-in again."
          end
        end
        session[:uType] = @user.sub_type
        redirect_to :action => "buyerhome", :controller => "my_deals", :id => "show", :token => encoded_str
      elsif !user.nil?
        http_agent = request.env['HTTP_USER_AGENT'].downcase
        begin
          Rails.logger.warn "1"
          @uas = UserActiveSession.first(:conditions => ["user_id = ? and created_at > ?", user.id, (Time.now - 30.minutes).in_time_zone.utc().strftime("%Y-%m-%d %H:%M:%S")]) unless user.nil?
          if !user.nil?
            if @uas.nil?
              Rails.logger.warn "uas is nil"
              user.user_active_sessions.destroy_all unless user.user_active_sessions.nil?
              @uas = UserActiveSession.new
              @uas.user_id = user.id
              Rails.logger.warn "Gone till here ..."
              @uas.session_id = request.session_options[:id]
              Rails.logger.warn "problem here"
              @uas.ip_address = request.remote_ip
              @uas.agent_browser = http_agent
              @uas.save
              Rails.logger.warn "logged in here"
            else
              if @uas.agent_browser != http_agent
                redirect_to :controller=>'my_deals', :action=>'index', :notice => "You are already logged in other browser/device, Please logout and log-in again."
              end
            end
            if user.user_status == "active"
              user.update_attribute :login_count, user.login_count.to_i + 1
              user.update_attribute :last_accessed_at, Time.now
              pwd = generate8
              encoded_str = ActiveSupport::Base64.encode64("#{user.email}:#{pwd}")
              user.update_attribute :password, Digest::SHA256.hexdigest(pwd)
              session[:uType] = user.sub_type
              address = user.address
              country_code = ""
              if !address.nil? && user.country_code.nil?
                user.update_attribute :country_code, "IN"
              elsif !user.country_code.nil?
              country_code = user.country_code
              else
                country_code = "US"
              end
              session[:uType] = user.sub_type
              redirect_to :action => "buyerhome", :controller => "my_deals", :id => "show", :token => encoded_str      
            else
              redirect_to :controller=>'my_deals', :action=>'index', :notice => "User account is inactive. Please send an email to support@mydeals247.com"
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
      else
        redirect_to(root_url, :notice => "Email already exists")
      end
    else
      redirect_to root_url
    end
  end

  def destroy
    unauthenticate
    redirect_to root_url
  end
  private

  def client
    unless @client
      @client = Facebook.auth.client
      @client.redirect_uri = "#{get_url}/facebooks/facebook_connected"
    end
    @client
  end
end
