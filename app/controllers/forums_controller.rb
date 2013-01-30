class ForumsController < ApplicationController
  load_and_authorize_resource :class => 'Forum', :only => :show
  helper 'topics'

  def index
    @forums = Forum.all
  end

  def show
    register_view

    @topics = if admin_or_moderator?(@forum)
                @forum.topics
              else
                @forum.topics.visible.approved_or_pending_review_for(current_user)
              end

    @topics = @topics.by_pinned_or_most_recent_post.page(params[:page]).per(20)

    respond_to do |format|
      format.html
      format.atom { render :layout => false }
    end
  end

  private
  def register_view
    @forum.register_view_by(current_user)
  end
end
