class TopicsController < ApplicationController
  helper 'posts'
  before_filter :authenticate_user, :except => [:show]
  before_filter :find_forum
  before_filter :block_spammers, :only => [:new, :create]

  def show
    if find_topic
      register_view
      @posts = @topic.posts
      unless admin_or_moderator?(@forum)
        @posts = @posts.approved_or_pending_review_for(current_user)
      end
      @posts = @posts.page(params[:page]).per(20)
    end
  end

  def new
    authorize! :create_topic, @forum
    @topic = @forum.topics.build
    @topic.posts.build
  end

  def create
    authorize! :create_topic, @forum
    @topic = @forum.topics.build(params[:topic], :as => :default)
    @topic.user = current_user
    if @topic.save
      flash[:notice] = t("forem.topic.created")
      redirect_to [@forum, @topic]
    else
      flash.now.alert = t("forem.topic.not_created")
      render :action => "new"
    end
  end

  def destroy
    @topic = @forum.topics.find(params[:id])
    if current_user == @topic.user || current_user.admin?
      @topic.destroy
      flash[:notice] = t("forem.topic.deleted")
    else
      flash.alert = t("forem.topic.cannot_delete")
    end

    redirect_to @topic.forum
  end

  def subscribe
    if find_topic
      @topic.subscribe_user(current_user.id)
      flash[:notice] = t("forem.topic.subscribed")
      redirect_to forum_topic_url(@topic.forum, @topic)
    end
  end

  def unsubscribe
    if find_topic
      @topic.unsubscribe_user(current_user.id)
      flash[:notice] = t("forem.topic.unsubscribed")
      redirect_to forum_topic_url(@topic.forum, @topic)
    end
  end

  private
  def find_forum
    @forum = Forum.find(params[:forum_id])
    authorize! :read, @forum
  end

  def find_topic
    begin
      scope = admin_or_moderator?(@forum) ? @forum.topics : @forum.topics.visible.approved_or_pending_review_for(current_user)
      @topic = scope.find(params[:id])
      authorize! :read, @topic
    rescue ActiveRecord::RecordNotFound
      flash.alert = t("forem.topic.not_found")
      redirect_to @forum and return
    end
  end

  def register_view
    @topic.register_view_by(current_user)
  end

  def block_spammers
    if current_user.state == "spam"
      flash[:alert] = t('forem.general.flagged_for_spam') + ' ' + t('forem.general.cannot_create_topic')
      redirect_to :back
    end
  end
end
