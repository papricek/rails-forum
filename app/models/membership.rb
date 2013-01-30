class Membership < ActiveRecord::Base
  belongs_to :group
  belongs_to :member

  attr_accessible :member_id, :group_id
end
