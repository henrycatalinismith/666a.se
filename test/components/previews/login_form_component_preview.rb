class LoginFormComponentPreview < ViewComponent::Preview
  def default
    render(LoginFormComponent.new(), params: {
      format: "",
      }
    )
  end
end