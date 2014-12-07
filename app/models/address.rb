class Address < ActiveRecord::Base
  belongs_to :user
  
  
  #validates :address, :presence => {:message => "Address can't be blank."}
  
  validates :city, :presence => {:message => "City can't be balnk."}
  #validates :country, :presence => {:message => "Please type the correct city name and wait until you see the drop-down list and select"}
  #validates :zip, :presence => {:message => "Zip/Pin can't be blank."}
  
  validates :mobile, :presence => {:message => "Mobile can't be blank."}
  
end
