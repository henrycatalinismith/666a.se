RailsAdmin.config do |config|
  config.main_app_name = ["666a"]
  config.asset_source = :importmap
  config.parent_controller = "::AdminActionController"

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == CancanCan ==
  config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/railsadminteam/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    collection :growth do
      link_icon do "fa fa-line-chart" end
      visible do
        case bindings[:abstract_model].model.name
        when "LabourLaw::Document" then true
        when "LabourLaw::Element" then true
        when "LabourLaw::Revision" then true
        when "LabourLaw::Translation" then true
        when "TimePeriod::Day" then true
        when "TimePeriod::Week" then true
        when "User::Account" then true
        when "User::Notification" then true
        when "User::Role" then true
        when "User::Subscription" then true
        else false end
      end
    end

    member :send_email do
      link_icon do "fa fa-envelope" end
      visible do
        case bindings[:abstract_model].model.name
        when "User::Notification" then true
        else false end
      end
      controller do
        proc do
          User::EmailJob.perform_later(@object.id)
          redirect_to back_or_index, notice: "job queued"
        end
      end
    end
  end
end
