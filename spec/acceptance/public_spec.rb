# encoding: utf-8
require 'spec_helper'

feature 'Public', '' do

  background do
    @user = FactoryGirl.create(:user)
    @forum = FactoryGirl.create(:forum)
    @topic = FactoryGirl.create(:approved_topic, forum: @forum)
    @post = FactoryGirl.create(:approved_post, topic: @topic, user: @user)
  end

  scenario 'Click through forum without login' do
    visit '/'
    click_link(@forum.title)
    page.should have_content(@user.nick)
    click_link(@topic.subject)
    page.should have_content(@topic.subject)
    page.should have_content(@post.text)
  end
end
