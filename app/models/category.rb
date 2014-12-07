class Category < ActiveRecord::Base
  acts_as_nested_set :order => :name
  validates_presence_of :name
  
  has_many :deals, :dependent => :destroy
  has_many :user_interests, :dependent => :destroy
  has_many :coupons, :dependent => :destroy
end
