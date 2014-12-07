ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address              => "mail.mydeals247.com",
  :port                 => 587,
  :domain               => "mydeals247.com",
  :password             => "MyDeals#77",
  :authentication       => "plain",
  :enable_starttls_auto => true,
  :openssl_verify_mode  => 'none'
}