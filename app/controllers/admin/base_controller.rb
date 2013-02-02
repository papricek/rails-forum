module Admin
  class BaseController < ApplicationController
    before_filter :authenticate_admin

    def index
      # TODO: perhaps gather some stats here to show on the admin page?
    end

    private

    def authenticate_admin
      if !current_user || !current_user.forem_admin?
        flash.alert = t("forem.errors.access_denied")
        redirect_to new_user_session_path
      end
    end
  end
end
