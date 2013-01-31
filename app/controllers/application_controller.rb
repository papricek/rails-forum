require 'cancan'

class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do
    redirect_to root_path, :alert => t("forem.access_denied")
  end

  def current_ability
    Ability.new(current_user)
  end

  before_filter :setup_breadcrumbs

  private
  def admin?
    current_user && current_user.forem_admin?
  end

  helper_method :admin?

  def admin_or_moderator?(forum)
    current_user && (current_user.forem_admin? || forum.moderator?(current_user))
  end

  helper_method :admin_or_moderator?

  def setup_breadcrumbs
    @breadcrumbs ||= []
  end

end
