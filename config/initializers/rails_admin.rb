RailsAdmin.config do |config|
  config.default_items_per_page = 64
  config.main_app_name = ["666a"]
  config.asset_source = :importmap
  config.parent_controller = "::AdminActionController"

  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)
  config.authorize_with :cancancan

  config.model "LabourLaw::Element" do
    field :element_text, :text
  end

  config.model "LabourLaw::Revision" do
    edit do
      configure :elements do
        orderable true
      end
    end
  end

  config.model "TimePeriod::Day" do
    list do
      sort_by :date
    end
  end

  config.model "TimePeriod::Week" do
    list do
      sort_by :created_at
    end
  end

  config.model "User::Notification" do
    list do
      sort_by :created_at
    end
  end

  config.model "WorkEnvironment::Document" do
    list do
      sort_by :created_at
    end
  end

  config.model "WorkEnvironment::Search" do
    list do
      sort_by :created_at
    end
  end

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
        bindings[:abstract_model].model.name == "User::Notification"
      end
      controller do
        proc do
          User::EmailJob.perform_later(@object.id)
          redirect_to back_or_index, notice: "job queued"
        end
      end
    end

    collection :retry_failed do
      link_icon do "fa fa-refresh" end
      visible do
        bindings[:abstract_model].model.name == "User::Notification"
      end
      controller do
        proc do
          User::RetryFailedEmailsJob.perform_later
          redirect_to back_or_index, notice: "job queued"
        end
      end
    end

    member :update_day do
      link_icon do "fa fa-refresh" end
      visible do
        bindings[:abstract_model].model.name == "TimePeriod::Day"
      end
      controller do
        proc do
          WorkEnvironment::DayJob.perform_later(
            @object.date,
            cascade: true,
            force: true,
            notify: true,
            purge: true
          )
          redirect_to back_or_index, notice: "job queued"
        end
      end
    end

    member :update_week do
      link_icon do "fa fa-refresh" end
      visible do
        bindings[:abstract_model].model.name == "TimePeriod::Week"
      end
      controller do
        proc do
          WorkEnvironment::WeekJob.perform_later(
            @object.week_code,
            cascade: true,
            force: true,
            notify: false
          )
          redirect_to back_or_index, notice: "job queued"
        end
      end
    end

    member :revision_elements do
      link_icon do "fa fa-eye" end
      visible do
        bindings[:abstract_model].model.name == "LabourLaw::Revision"
      end
    end

    member :element_sentences do
      link_icon do "fa fa-eye" end
      visible do
        bindings[:abstract_model].model.name == "LabourLaw::Element"
      end
    end
  end
end
