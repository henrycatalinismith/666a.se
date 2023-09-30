class RegistrationFormComponentPreview < ViewComponent::Preview
  def with_default_title
    render(RegistrationFormComponent.new())
  end
end