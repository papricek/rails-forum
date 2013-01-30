require 'cancan'

class Ability
  include CanCan::Ability

  class_attribute :abilities
  self.abilities = Set.new

  # Allows us to go beyond the standard cancan initialize method which makes it difficult for engines to
  # modify the default +Ability+ of an application.  The +ability+ argument must be a class that includes
  # the +CanCan::Ability+ module.  The registered ability should behave properly as a stand-alone class
  # and therefore should be easy to test in isolation.
  def self.register_ability(ability)
    self.abilities.add(ability)
  end

  def self.remove_ability(ability)
    self.abilities.delete(ability)
  end

  def initialize(user)
    user ||= User.new

    can :read, Category do |category|
      user.can_read_category?(category)
    end

    can :read, Topic do |topic|
      user.can_read_forum?(topic.forum) && user.can_read_topic?(topic)
    end

    if user.can_read_forums?
      can :read, Forum do |forum|
        user.can_read_category?(forum.category) && user.can_read_forum?(forum)
      end
    end

    can :create_topic, Forum do |forum|
      can?(:read, forum) && user.can_create_topics?(forum)
    end

    can :reply, Topic do |topic|
      user.can_reply_to_topic?(topic)
    end

    can :edit_post, Forum do |forum|
      user.can_editm_posts?(forum)
    end

    can :moderate, Forum do |forum|
      user.can_moderate_forum?(forum) || user.forem_admin?
    end

    #include any abilities registered by extensions, etc.
    Ability.abilities.each do |clazz|
      ability = clazz.send(:new, user)
      @rules = rules + ability.send(:rules)
    end
  end
end
