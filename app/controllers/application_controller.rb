require "net/http"
require 'rubygems'
require 'nokogiri'
require 'rexml/document'
require "net/https"
require 'uri'
class ApplicationController < ActionController::Base
  def price_format(price)
    return "%.2f" % price
  end
  def year_format(year)
    return "%.1f" % year
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
        Rails.logger.warn latilong_str
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
  def get_url
    global_url = request.protocol().to_s + request.host.to_s    
    if !request.domain || request.domain == "localhost"
      global_url += ":" + request.port.to_s
    end
    return global_url
  end
  def generate6
    Digest::SHA1.hexdigest(Time.now.to_s + rand(123456789123456789).to_s)[1..6]
  end
  def generate4
    Digest::SHA1.hexdigest(Time.now.to_s + rand(123456789123456789).to_s)[1..4]
  end
  def generate10
    str = "%010d" % Time.now.to_i
    str[0] = str[0] == 48 ? 51 : str[0]
    return str
  end

  def generate8
    str = Digest::SHA1.hexdigest(Time.now.to_s + rand(123456789123456789).to_s)[1..8]
    return str.upcase
  end

  def generate12
    str = Digest::SHA1.hexdigest(Time.now.to_s + rand(123456789123456789).to_s)[1..12]
    return str.upcase
  end
  
  def generate16
    str = Digest::SHA1.hexdigest(Time.now.to_s + rand(123456789123456789).to_s)[1..16]
    return str.upcase
  end  
  
  
  def generate30
    Digest::SHA1.hexdigest(Time.now.to_s + rand(123456789123456789).to_s)[1..30]
  end
end
