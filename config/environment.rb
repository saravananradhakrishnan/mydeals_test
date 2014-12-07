# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8
LocalDeals::Application.initialize!
Spawn::default_options(:method => {:method=>:thread, :nice=>7})
Mime::Type.register "application/pdf", :pdf 

$currency_type = "Rs"
$currency_symbol = "INR"
$desc_size = 140
$iptoloc_api = "http://api.ipinfodb.com/v3/ip-city/?key=3bde61507889fbb7cc489a2e15bc489b538954fefed67f2b4f2a720edcf1ad7b"
$time_diff = "5.5"
$date_time_format = "%m-%d-%Y %H:%M"
$date_format = "%m-%d-%Y"
$geonames_api = "http://api.geonames.org/searchJSON?country=IN"
$country_name = "India"
$version_date = "1.9.1 - 08312011"
$ads_country = "India"
$sms_country = "India"
$cab_category = "CAB OR TAXI Booking"
$cab_point2point = "Pick-up and Drop-off"
$cab_package = "Tour OR Long Distance Package"
$service_category = "Services OR Help Needed"
$hotel_category = "Hotel Booking"
$education_category = "Educational Training"
$bulk_order_qty = 5
$client_token = "bWF0dC5ob29wZXI6RmU3MzFjb21l"
$b2b_request_expiry = 72
$job_enable = true
#$api_host = "localhost:3000"
$api_host = "api.mydeals247.com"