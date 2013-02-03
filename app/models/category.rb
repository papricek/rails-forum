require 'friendly_id'

class Category < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged

  has_many :forums
  validates :name, :presence => true
  attr_accessible :name

  def to_s
    name
  end

end
