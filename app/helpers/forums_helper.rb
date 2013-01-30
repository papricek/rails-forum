module ForumsHelper
  def topics_count(forum)
    if admin_or_moderator?(forum)
      forum.topics.count
    else
      forum.topics.approved.count
    end
  end

  def posts_count(forum)
    if admin_or_moderator?(forum)
      forum.posts.count
    else
      forum.posts.approved.count
    end
  end
end
