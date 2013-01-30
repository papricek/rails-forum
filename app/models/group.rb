class Group < ActiveRecord::Base
  validates :name, :presence => true

  has_many :memberships
  has_many :members, :through => :memberships

  attr_accessible :name

  def to_s
    name
  end
end
