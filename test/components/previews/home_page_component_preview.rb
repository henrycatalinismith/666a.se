class HomePageComponentPreview < ViewComponent::Preview
  def default
    render(HomePageComponent.new())
  end
end