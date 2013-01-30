class SubscriptionMailer < ActionMailer::Base
  default :from => 'info@rails-forum.cz'

  def topic_reply(post_id, subscriber_id)
    # only pass id to make it easier to send emails using resque
    @post = Post.find(post_id)
    @user = User.find(subscriber_id)

    mail(:to => @user.email, :subject => I18n.t('forem.topic.received_reply'))
  end
end
