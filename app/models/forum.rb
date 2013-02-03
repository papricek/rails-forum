require 'friendly_id'

class Forum < ActiveRecord::Base
  include Concerns::Viewable

  extend FriendlyId
  friendly_id :name, :use => :slugged

  belongs_to :category

  has_many :topics, :dependent => :destroy
  has_many :posts, :through => :topics, :dependent => :destroy

  validates :name, :description, :presence => true

  attr_accessible :category_id, :title, :name, :description, :moderator_ids

  alias_attribute :title, :name

  # Fix for #339
  default_scope order('name ASC')

  def last_post_for(current_user)
    if current_user && (current_user.admin? || moderator?(current_user))
      posts.last
    else
      last_visible_post(current_user)
    end
  end

  def last_visible_post(current_user)
    posts.approved_or_pending_review_for(current_user).last
  end

  def moderator?(user)
    user && (['administrator', 'moderator'].include?(user.role))
  end
end
