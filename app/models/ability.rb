# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?
    return unless user.role?("admin")

    can :access, :rails_admin
    can :manage, :dashboard

    if user.role?("labour_law_admin")
      can :manage, LabourLaw::Document
      can :manage, LabourLaw::Element
      can :manage, LabourLaw::Phrase
      can :manage, LabourLaw::Revision
      can :manage, LabourLaw::Sentence
    end

    if user.role?("time_period_admin")
      can :manage, TimePeriod::Day
      can :manage, TimePeriod::Week
    end

    if user.role?("user_admin")
      can :manage, User::Account
      can :manage, User::Authorization
      can :manage, User::Notification
      can :manage, User::Role
      can :manage, User::Subscription
    end

    if user.role?("work_environment_admin")
      can :manage, WorkEnvironment::Document
      can :manage, WorkEnvironment::Search
    end
  end
end
