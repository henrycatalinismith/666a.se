class NotificationEmailComponentPreview < ViewComponent::Preview

  def html
    @user = User.new(name: "Example User")
    @result = Result.new(
      company_name: "EXEMPEL AB",
      document_code: "000000-0000",
      document_type: "Exempel",
    )
    render(NotificationEmailComponent.new(format: "html", user: @user, result: @result))
  end

  def text
    @user = User.new(name: "Example User")
    @result = Result.new(
      company_name: "EXEMPEL AB",
      document_code: "000000-0000",
      document_type: "Exempel",
    )
    render(NotificationEmailComponent.new(format: "text", user: @user, result: @result))
  end

end