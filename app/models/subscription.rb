class Subscription < ActiveRecord::Base
  belongs_to :topic
  belongs_to :subscriber, :class_name => 'User'

  validates :subscriber_id, :presence => true

  attr_accessible :subscriber_id

  def send_notification(post_id)
    SubscriptionMailer.topic_reply(post_id, subscriber.id).deliver
  end
end
