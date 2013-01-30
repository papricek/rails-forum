class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include DefaultPermissions

  ROLES = [:member, :moderator, :guest, :administrator]

  attr_accessible :email, :password, :password_confirmation, :remember_me, :nick, :name, :url

  before_save :set_role

  has_many :posts, :foreign_key => "user_id"
  has_many :topics, :foreign_key => "user_id"
  has_many :memberships, :foreign_key => "member_id"
  has_many :groups, :through => :memberships, :source => :group

  def needs_moderation?
    forem_state == 'approved'
  end

  private
  def set_role
    self.role ||= 'member'
  end

end
