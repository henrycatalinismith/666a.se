class LoginFormComponentPreview < ViewComponent::Preview
  def default
    render(LoginFormComponent.new())
  end
end