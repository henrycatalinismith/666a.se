# frozen_string_literal: true

class HomeTargetAudienceComponent < ViewComponent::Base
  def initialize
    @people = [
      {
        icon: "fa-shield",
        heading: "target_audience_member.safety_officer.title",
        text: "target_audience_member.safety_officer.text"
      },
      {
        icon: "fa-hat-wizard",
        heading: "target_audience_member.union_rep.title",
        text: "target_audience_member.union_rep.text"
      },
      {
        icon: "fa-hammer",
        heading: "target_audience_member.employee.title",
        text: "target_audience_member.employee.text"
      },
      {
        icon: "fa-briefcase",
        heading: "target_audience_member.ombudsman.title",
        text: "target_audience_member.ombudsman.text"
      },
      {
        icon: "fa-fire",
        heading: "target_audience_member.organizer.title",
        text: "target_audience_member.organizer.text"
      },
      {
        icon: "fa-newspaper",
        heading: "target_audience_member.journalist.title",
        text: "target_audience_member.journalist.text"
      }
    ]
  end
end
