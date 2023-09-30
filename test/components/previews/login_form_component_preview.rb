class LoginFormComponentPreview < ViewComponent::Preview
  def with_default_title
    render(LoginFormComponent.new())
  end
end