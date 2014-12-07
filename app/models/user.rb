class User < ActiveRecord::Base
  
  
  validates :email, :presence => {:message => "Email address can't be left balnk."}, 
                  :length => {:minimum => 3, :maximum => 254, :message => "Email length is too short (minimum is 5 characters)."},
                  :uniqueness => {:message => "Email address already exists"},
                  :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Please enter a valid email address."}
                  

  
  validates :password, :presence => {:message => "Passwords can't be left blank."}, 
                    :length => {:minimum => 6, :maximum => 254, :message => "Password length is too short (minimum is 6 characters)."}
                    
  validates_confirmation_of :password  , :message => "Passwords do not match."
                  
  validates :fname, :presence => {:message => "First Name can't be left balnk."}, 
                  :length => {:minimum => 1, :maximum => 20, :message => "First Name is too short (minimum is 1 characters)."}
                  
  validates :lname, :presence =>  {:message => "Last Name can't be left balnk."}, 
                  :length => {:minimum => 1, :maximum => 20, :message => "Last Name is too short (minimum is 1 characters)."}
  
  #apply_simple_captcha :message => "The secret Image and code were different", :add_to_base => true
  
  has_one :merchant, :dependent => :destroy
  has_one :user_mydeals_ad_code, :dependent => :destroy
  has_one :address, :dependent => :destroy
  has_one :crm_ref, :dependent => :destroy
  has_one :user_pref, :dependent => :destroy
  has_one :seller_pref, :dependent => :destroy
  has_many :user_interests, :dependent => :destroy
  has_many :seller_interests, :dependent => :destroy
  has_many :user_active_sessions, :dependent => :destroy
  has_many :user_toolbar_prefs, :dependent => :destroy
  has_many :user_addition_toolbar_prefs, :dependent => :destroy
  has_many :user_requests, :dependent => :destroy
  has_many :merchant_offers, :dependent => :destroy
  has_many :merchant_books_library, :dependent => :destroy
  has_many :bought_deals, :dependent => :destroy
  has_many :bought_offers, :dependent => :destroy
  has_many :bought_coupons, :dependent => :destroy
  has_many :user_assigned_acl, :dependent => :destroy
  has_many :job_posting, :dependent => :destroy
  has_one :job_profile, :dependent => :destroy

  
  scope :without_admin, :conditions => ["sub_type != 'superadmin'"]
  scope :with_utype, lambda {|utype| utype.present? ? {:conditions => ["user_type = ? and sub_type is not null", utype]} : {}}
  scope :with_stype, lambda {|stype| stype.present?  ? {:conditions => ["sub_type = ?", stype]} : {}}
  scope :with_sellertype, lambda {|mtype| mtype.present?  ? {:conditions => ["sub_type = ? or sub_type = ?", 'seller', 'buysell']} : {}}
  scope :with_partner, lambda {|ptype| ptype.present? ? {:conditions => ["sub_type = 'partner' or sub_type = 'franchisee' or sub_type = 'iPartner' or sub_type = 'wPartner'"]} : {}}
  scope :with_status, lambda {|status| status.present? ? {:conditions => ["user_status = ?", status]} : {}}
  scope :with_fb_user, lambda {|typ| typ.present? && typ == "Yes" ? {:conditions => ["facebook_uid is not null"]} : {}}
  scope :with_job_user, lambda {|entity| entity.present?  ? {:conditions => ["user_entity = ?", entity]} : {}}
  scope :with_reg_user, lambda {|typ| typ.present? && typ == "Yes" ? {:conditions => ["facebook_uid is null"]} : {}}
  has_attached_file :user_img,
  :styles => {
    :tiny => "50x50#",
    :thumb=> "100x90#",
    :small => "200x190#",
    :medium => "300x300#>",
    :zoom_small => "308x247>",
    :zoom_big => "1280x1024>" }
  def self.authenticate(email, password)
    user = User.find(:first, :conditions => ['email = ?' , email])
    if user.blank? || Digest::SHA256.hexdigest(password) != user.password
      user = nil
    end
    return user
  end
  
  def self.just_authenticate(email, password)
    user = User.find(:first, :conditions => ['email = ?' , email])
    if user.blank? || Digest::SHA256.hexdigest(password) != user.password
      user = nil
    end
    return user
  end
  
  def self.chk_user(username, password,typ)
    user = User.find(:first, :conditions => ['username = ?' , username])
    if user.blank? || Digest::SHA256.hexdigest(password) != user.password || user.user_type != typ
      user = nil
    end
    return user
  end
  
  def encryptPass(pass)
    self.password = Digest::SHA256.hexdigest(pass);
  end 
end
