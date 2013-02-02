# Defines a whole bunch of permissions for Forem
# Access (most) areas by default
module DefaultPermissions
  extend ActiveSupport::Concern

  included do
    unless method_defined?(:can_read_forums?)
      def can_read_forums?
        true
      end
    end

    unless method_defined?(:can_read_forum?)
      def can_read_forum?(forum)
        true
      end
    end

    unless method_defined?(:can_create_topics?)
      def can_create_topics?(forum)
        true
      end
    end

    unless method_defined?(:can_reply_to_topic?)
      def can_reply_to_topic?(topic)
        true
      end
    end

    unless method_defined?(:can_edit_posts?)
      def can_edit_posts?(forum)
        true
      end
    end

    unless method_defined?(:can_read_topic?)
      def can_read_topic?(topic)
        !topic.hidden? || forem_admin?
      end
    end

    unless method_defined?(:can_moderate_forum?)
      def can_moderate_forum?(forum)
        forum.moderator?(self)
      end
    end
  end
end
