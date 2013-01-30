class RemoveForemPrefixes < ActiveRecord::Migration
  def change
    rename_table :forem_categories, :categories
    rename_table :forem_forums, :forums
    rename_table :forem_groups, :groups
    rename_table :forem_memberships, :memberships
    rename_table :forem_moderator_groups, :moderator_groups
    rename_table :forem_posts, :posts
    rename_table :forem_subscriptions, :subscriptions
    rename_table :forem_topics, :topics
    rename_table :forem_views, :views

    rename_index :categories, :index_forem_categories_on_slug, :index_categories_on_slug
    rename_index :forums, :index_forem_forums_on_slug, :index_forums_on_slug
    rename_index :groups, :index_forem_groups_on_name, :index_groups_on_name
    rename_index :memberships, :index_forem_memberships_on_group_id, :index_memberships_on_group_id
    rename_index :moderator_groups, :index_forem_moderator_groups_on_forum_id, :index_moderator_groups_on_forum_id
    rename_index :posts, :index_forem_posts_on_reply_to_id, :index_posts_on_reply_to_id
    rename_index :posts, :index_forem_posts_on_state, :index_posts_on_state
    rename_index :posts, :index_forem_posts_on_topic_id, :index_posts_on_topic_id
    rename_index :posts, :index_forem_posts_on_user_id, :index_posts_on_user_id

    rename_index :topics, :index_forem_topics_on_forum_id, :index_topics_on_forum_id
    rename_index :topics, :index_forem_topics_on_slug, :index_topics_on_slug
    rename_index :topics, :index_forem_topics_on_state, :index_topics_on_state
    rename_index :topics, :index_forem_topics_on_user_id, :index_topics_on_user_id

    rename_index :views, :index_forem_views_on_updated_at, :index_views_on_updated_at
    rename_index :views, :index_forem_views_on_user_id, :index_views_on_user_id
    rename_index :views, :index_forem_views_on_topic_id, :index_views_on_topic_id
  end
end
