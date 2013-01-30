require 'pp'
require 'iconv'

STDOUT.sync = true

namespace :db do
  task :import => :environment do

    class CategoryOld < ActiveRecord::Base
      establish_connection :old
      set_table_name "categories"
    end

    class ForumOld < ActiveRecord::Base
      establish_connection :old
      set_table_name "forums"
    end

    class TopicOld < ActiveRecord::Base
      establish_connection :old
      set_table_name "topics"
    end

    class PostOld < ActiveRecord::Base
      establish_connection :old
      set_table_name "posts"
    end

    class UserOld < ActiveRecord::Base
      establish_connection :old
      set_table_name "users"
    end

    class GroupOld < ActiveRecord::Base
      establish_connection :old
      set_table_name "groups"
    end

    def __(string)
      fix_cp1252_utf8(string.to_s)
    end

    def fix_cp1252_utf8(text)
      text.encode('cp1252',
                  :fallback => {
                      "\u0081" => "\x81".force_encoding("cp1252"),
                      "\u008D" => "\x8D".force_encoding("cp1252"),
                      "\u008F" => "\x8F".force_encoding("cp1252"),
                      "\u0090" => "\x90".force_encoding("cp1252"),
                      "\u009D" => "\x9D".force_encoding("cp1252")
                  }).force_encoding("utf-8")
    end

    puts "Users: #{UserOld.count}"
    UserOld.all.each do |u|
      group = GroupOld.find u.group_id
      group_name = group.present? ? group.g_title.underscore.singularize : ''
      random_string = SecureRandom.hex(4)
      user = User.create(email: u.email,
                         nick: __(u.username),
                         name: __(u.realname),
                         url: u.url,
                         password: random_string,
                         password_confirmation: random_string)
      if group_name == 'administrator'
        user.role = 'administrator'
        user.forem_admin = true
        user.save
      else
        user.role = 'member'
        user.save
      end
      puts "#{user.id} / #{user.nick} / #{user.email} / #{user.name} / #{user.url} / #{user.role}"
    end


    #ids = [673, 674, 675, 679, 684, 693, 1121, 1118, 1080, 1073, 1059, 1004, 874, 840, 841,
    #       811, 801, 633, 684, 679, 678, 674, 675, 670, 667]
    #UserOld.where('id > 670').where('id NOT IN(?)', ids).destroy_all
    #UserOld.where('id IN (?)', [665, 657, 669, ]).destroy_all
    category = Category.create(name: "General")
    ForumOld.all.each do |forum_old|
      forum = Forum.new(name: __(forum_old.forum_name),
                               description: __(forum_old.forum_desc || '&nbsp;'))
      forum.category = category
      forum.save!
      TopicOld.where(forum_id: forum_old.id).each do |topic_old|
        topic = Topic.new(subject: __(topic_old.subject))
        topic.forum = forum
        topic.created_at = Time.at(topic_old.posted) if topic_old.posted
        topic.updated_at = Time.at(topic_old.last_post) if topic_old.last_post
        topic.views_count = topic_old.num_views

        poster = UserOld.where('username = ? OR realname = ? ', topic_old.poster, topic_old.poster).first
        if poster && user = User.find_by_email(poster.email)
          topic.user = user
        end
        puts topic.inspect
        topic.save!
        topic.update_column(:created_at, Time.at(topic_old.posted)) if topic_old.posted
        topic.update_column(:updated_at, Time.at(topic_old.last_post)) if topic_old.last_post

        PostOld.where(:topic_id => topic_old.id).order('posted desc').each do |p|
          poster = UserOld.find_by_id(p.poster_id)
          next if poster.blank?
          user = User.find_by_email(poster.email)
          next if user.blank?
          post = topic.posts.build(text: __(p.message))
          post.user_id = user.id
          post.save!
          post.update_column(:created_at, Time.at(p.posted)) if p.posted
          post.update_column(:updated_at, Time.at(p.posted)) if p.posted
        end
      end
    end
    Topic.update_all("state = 'approved'")
    Post.update_all("state = 'approved'")
    User.update_all("forem_state = 'approved'")

  end
end
