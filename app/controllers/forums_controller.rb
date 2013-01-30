class ForumsController < ApplicationController
  load_and_authorize_resource :class => 'Forum', :only => :show
  helper 'topics'

  def index
    @categories = Category.all
  end

  def show
    register_view

    @topics = if admin_or_moderator?(@forum)
                @forum.topics
              else
                @forum.topics.visible.approved_or_pending_review_for(forem_user)
              end

    @topics = @topics.by_pinned_or_most_recent_post.page(params[:page]).per(Forem.per_page)

    respond_to do |format|
      format.html
      format.atom { render :layout => false }
    end
  end

  private
  def register_view
    @forum.register_view_by(forem_user)
  end
end
