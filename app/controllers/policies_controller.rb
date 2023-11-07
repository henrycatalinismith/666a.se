require "redcarpet"

class PoliciesController < ApplicationController
  def accessibility
    policy("accessibility")
    render template: "policies/show", layout: "internal"
  end

  def privacy
    policy("privacy")
    render template: "policies/show", layout: "internal"
  end

  def terms
    policy("terms")
    render template: "policies/show", layout: "internal"
  end

  private

  def policy(slug)
    @policy = Policy.find_by(slug: slug)
    @policies = Policy.all
  end
end
